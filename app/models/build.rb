class Build < ActiveRecord::Base
  self.table_name = 'model.build'
  self.primary_key = 'build_id'

  COVERAGE_RESULT_CLASS_NAMES = [
    'Genome::InstrumentData::AlignmentResult::Merged::CoverageStats',
    'Genome::InstrumentData::AlignmentResult::Merged::RefCov',
  ]

  has_many :events
  has_many :software_result_users, foreign_key: :user_id
  has_many :software_results, through: :software_result_users
  has_many :coverage_software_results, -> { where(class_name: COVERAGE_RESULT_CLASS_NAMES) }, through: :software_result_users, source: :software_result
  has_many :software_result_metrics, through: :software_results
  has_many :build_metrics
  has_many :build_inputs, inverse_of: :build
  belongs_to :model, inverse_of: :builds

  def coverage_report_metrics
    self.coverage_depths_mapping.merge(self.enrichment_hash_mapping).merge(alignment_summary_metrics_mapping)

  end

  def coverage_depths_mapping
    metric_names = self.coverage_minimum_depths
    Hash[software_result_metrics.select{|m| metric_names.include?(m.metric_name)}.collect{|m| [/(\d+)_mean_depth/.match(m.metric_name)[1], m.metric_value]}]
  end

  def enrichment_hash_mapping
    m = self.enrichment_metrics_hash  
    enrichment = Hash.new
    enrichment['theoretical_max_enrichment_factor'] = (100 / ((m['target_total_bp'].to_f / m['genome_total_bp'].to_f) * 100)).round(1)
    enrichment['alignment_v1_unique_on_target_enrichment_factor'] = (((m['alignment-wingspan_0_unique_target_aligned_bp'].to_f / (m['alignment-wingspan_0_total_aligned_bp'].to_f + m['alignment-wingspan_0_total_unaligned_bp'].to_f)) * 100) / ((m['target_total_bp'].to_f / m['genome_total_bp'].to_f) * 100)).round(1) 
    enrichment['alignemnt_v1_total_on_target_enrichment_factor']  = ((((m['alignment-wingspan_0_unique_target_aligned_bp'].to_f + m['alignment-wingspan_0_duplicate_target_aligned_bp'].to_f) / (m['alignment-wingspan_0_total_aligned_bp'].to_f + m['alignment-wingspan_0_total_unaligned_bp'].to_f)) * 100) / ((m['target_total_bp'].to_f / m['genome_total_bp'].to_f) * 100)).round(1)
    enrichment['alignment_v2_unique_on_target_enrichment_factor'] = (((m['alignment-v2-wingspan_0_unique_target_aligned_bp'].to_f / (m['alignment-v2-wingspan_0_total_aligned_bp'].to_f + m['alignment-v2-wingspan_0_total_unaligned_bp'].to_f)) * 100) / ((m['target_total_bp'].to_f / m['genome_total_bp'].to_f) * 100)).round(1) 
    enrichment['alignemnt_v2_total_on_target_enrichment_factor']  = ((((m['alignment-v2-wingspan_0_unique_target_aligned_bp'].to_f + m['alignment-v2-wingspan_0_duplicate_target_aligned_bp'].to_f) / (m['alignment-v2-wingspan_0_total_aligned_bp'].to_f + m['alignment-v2-wingspan_0_total_unaligned_bp'].to_f)) * 100) / ((m['target_total_bp'].to_f / m['genome_total_bp'].to_f) * 100)).round(1)
    enrichment
  end

  def enrichment_metrics_hash
    Hash[self.enrichment_metrics.collect{|m| [m.metric_name, m.metric_value]}]
  end

  def alignment_summary_metrics_mapping
    Hash[self.alignment_summary_metrics.collect{|m| [m.metric_name, m.metric_value]}]
  end

  def enrichment_metrics
    metric_names = [
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
    software_result_metrics.select{|m| metric_names.include?(m.metric_name)}
  end

  def alignment_summary_metrics
    metric_names = [
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
    software_result_metrics.select{|m| metric_names.include?(m.metric_name)}
  end

  def coverage_minimum_depths
    coverage_software_results
      .flat_map(&:software_result_parameters)
      .select{ |p| p.name == 'minimum_depths' }
      .first
      .param_value
      .split(',')
      .map { |n| "coverage-wingspan_0_#{n}_mean_depth" }
  end
end
