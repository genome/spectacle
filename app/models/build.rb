class Build < ActiveRecord::Base
  self.table_name = 'model.build'
  self.primary_key = 'build_id'

  COVERAGE_RESULT_CLASS_NAMES = [
    'Genome::InstrumentData::AlignmentResult::Merged::CoverageStats',
    'Genome::InstrumentData::AlignmentResult::Merged::RefCov',
  ]

  ENRICHMENT_METRIC_NAMES = [
    'genome_total_bp',
    'target_total_bp',
    'alignment-wingspan_0_total_unaligned_bp',
    'alignment-wingspan_0_total_aligned_bp',
    'alignment-wingspan_0_duplicate_target_aligned_bp',
    'alignment-wingspan_0_unique_target_aligned_bp',
    'alignment-v2-wingspan_0_total_unaligned_bp',
    'alignment-v2-wingspan_0_total_aligned_bp',
    'alignment-v2-wingspan_0_duplicate_target_aligned_bp',
    'alignment-v2-wingspan_0_unique_target_aligned_bp',
  ]

  ALIGNMENT_SUMMARY_METRIC_NAMES = [
    'alignment-wingspan_0_total_unaligned_bp',
    'alignment-v2-wingspan_0_total_unaligned_bp',
    'alignment-wingspan_0_duplicate_off_target_aligned_bp',
    'alignment-v2-wingspan_0_duplicate_off_target_aligned_bp',
    'alignment-wingspan_0_duplicate_target_aligned_bp',
    'alignment-v2-wingspan_0_duplicate_target_aligned_bp',
    'alignment-wingspan_0_total_aligned_bp',
    'alignment-v2-wingspan_0_total_aligned_bp',
    'alignment-wingspan_0_unique_off_target_aligned_bp',
    'alignment-wingspan_500_unique_off_target_aligned_bp',
    'alignment-v2-wingspan_0_unique_off_target_aligned_bp',
    'alignment-v2-wingspan_500_unique_off_target_aligned_bp',
  ]

  has_many :events
  has_many :software_result_users, foreign_key: :user_id
  has_many :software_results, through: :software_result_users
  has_many :coverage_software_results, -> { where(class_name: COVERAGE_RESULT_CLASS_NAMES) }, through: :software_result_users, source: :software_result

  has_many :software_result_metrics, through: :software_results
  has_many :enrichment_metrics, -> { where(metric_name: ENRICHMENT_METRIC_NAMES) }, through: :software_results, source: :software_result_metrics
  has_many :alignment_summary_metrics, -> { where(metric_name: ALIGNMENT_SUMMARY_METRIC_NAMES) }, through: :software_results, source: :software_result_metrics

  has_many :build_metrics
  has_many :build_inputs, inverse_of: :build
  belongs_to :model, inverse_of: :builds

  def coverage_report_metrics
    coverage_depths_hash
      .merge(calculated_enrichment_metrics_hash)
      .merge(alignment_summary_metrics_hash)
  end

  def coverage_depths_hash
    software_result_metrics.where(metric_name: coverage_minimum_depths)
      .map { |m| [/(\d+)_mean_depth/.match(m.metric_name)[1], m.metric_value] }
      .to_h
  end

  def calculated_enrichment_metrics_hash
    m = enrichment_metrics_hash
    genome_total_bp                = m['genome_total_bp'].to_f
    target_total_bp                = m['target_total_bp'].to_f
    v1_unique_target_aligned_bp    = m['alignment-wingspan_0_unique_target_aligned_bp'].to_f
    v1_total_aligned_bp            = m['alignment-wingspan_0_total_aligned_bp'].to_f
    v1_total_unaligned_bp          = m['alignment-wingspan_0_total_unaligned_bp'].to_f
    v1_duplicate_target_aligned_bp = m['alignment-wingspan_0_duplicate_target_aligned_bp'].to_f
    v2_unique_target_aligned_bp    = m['alignment-v2-wingspan_0_unique_target_aligned_bp'].to_f
    v2_total_aligned_bp            = m['alignment-v2-wingspan_0_total_aligned_bp'].to_f
    v2_total_unaligned_bp          = m['alignment-v2-wingspan_0_total_unaligned_bp'].to_f
    v2_duplicate_target_aligned_bp = m['alignment-v2-wingspan_0_duplicate_target_aligned_bp'].to_f

    Hash.new.tap do |e|
      e['theoretical_max_enrichment_factor'] = calculate_theoretical_max_enrichment_factor(target_total_bp, genome_total_bp)

      e['alignment_v1_unique_on_target_enrichment_factor']  =  calculate_unique_on_target_enrichment_factor(
        v1_unique_target_aligned_bp,
        v1_total_aligned_bp,
        v1_total_unaligned_bp,
        target_total_bp,
        genome_total_bp
      )

      e['alignment_v1_total_on_target_enrichment_factor'] = calculate_total_on_target_enrichment_factor(
        v1_unique_target_aligned_bp,
        v1_duplicate_target_aligned_bp,
        v1_total_aligned_bp,
        v1_total_unaligned_bp,
        target_total_bp,
        genome_total_bp
      )

      e['alignment_v2_unique_on_target_enrichment_factor'] = calculate_unique_on_target_enrichment_factor(
        v2_unique_target_aligned_bp,
        v2_total_aligned_bp,
        v2_total_unaligned_bp,
        target_total_bp,
        genome_total_bp
      )

      e['alignment_v2_total_on_target_enrichment_factor'] = calculate_total_on_target_enrichment_factor(
        v2_unique_target_aligned_bp,
        v2_duplicate_target_aligned_bp,
        v2_total_aligned_bp,
        v2_total_unaligned_bp,
        target_total_bp,
        genome_total_bp
      )
    end
  end

  def calculate_theoretical_max_enrichment_factor(target_total_bp, genome_total_bp)
    (100 / ((target_total_bp / genome_total_bp) * 100)).round(1)
  end

  def calculate_unique_on_target_enrichment_factor(unique_target_aligned_bp, total_aligned_bp, total_unaligned_bp, target_total_bp, genome_total_bp)
     (((unique_target_aligned_bp / (total_aligned_bp + total_unaligned_bp)) * 100) / ((target_total_bp / genome_total_bp) * 100)).round(1)
  end

  def calculate_total_on_target_enrichment_factor(unique_target_aligned_bp, duplicate_target_aligned_bp, total_aligned_bp, total_unaligned_bp, target_total_bp, genome_total_bp)
    ((((unique_target_aligned_bp + duplicate_target_aligned_bp) / (total_aligned_bp + total_unaligned_bp)) * 100) / ((target_total_bp / genome_total_bp) * 100)).round(1)
  end

  def enrichment_metrics_hash
    enrichment_metrics.map{ |m| [m.metric_name, m.metric_value] }.to_h
  end

  def alignment_summary_metrics_hash
    alignment_summary_metrics.map{ |m| [m.metric_name, m.metric_value] }.to_h
  end

  def coverage_minimum_depths
    @coverage_minimum_depths ||= coverage_software_results
      .flat_map(&:software_result_parameters)
      .select{ |p| p.name == 'minimum_depths' }
      .first
      .param_value
      .split(',')
      .map { |n| "coverage-wingspan_0_#{n}_mean_depth" }
  end
end
