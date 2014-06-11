class CoverageReport
  def self.from_build_ids(build_ids)
    build_ids = Array(build_ids)
    coverage_report_query.find(build_ids).map do |build|
      CoverageReport.new(build)
    end
  end

  def self.coverage_result_class_names
    @coverage_result_class_names = [
      'Genome::InstrumentData::AlignmentResult::Merged::CoverageStats',
      'Genome::InstrumentData::AlignmentResult::Merged::RefCov',
    ]
  end

  def self.enrichment_metric_names
    @enrichment_metric_names ||= [
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
  end

  def self.alignment_summary_metric_names
    @alignment_summary_metric_names ||= [
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
  end

  def build_id
    @build.id
  end

  def coverage_report_metrics
    coverage_depths_hash
      .merge(calculated_enrichment_metrics_hash)
      .merge(alignment_summary_metrics_hash)
  end

  def coverage_depths_hash
    Hash[@build.software_result_metrics.where(metric_name: coverage_minimum_depths)
      .map { |m| [/(\d+)_mean_depth/.match(m.metric_name)[1], m.metric_value] }]
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
    Hash[@build.enrichment_metrics.map{ |m| [m.metric_name, m.metric_value] }]
  end

  def alignment_summary_metrics_hash
    Hash[@build.alignment_summary_metrics.map{ |m| [m.metric_name, m.metric_value] }]
  end

  def coverage_minimum_depths
    @coverage_minimum_depths ||= @build.coverage_software_results
      .flat_map(&:software_result_parameters)
      .select{ |p| p.name == 'minimum_depths' }
      .first
      .param_value
      .split(',')
      .map { |n| "coverage-wingspan_0_#{n}_mean_depth" }
  rescue
    []
  end

  private
  def initialize(build)
    @build = build
  end

  def self.coverage_report_query
    Build.includes(:enrichment_metrics)
      .includes(:alignment_summary_metrics)
      .includes(coverage_software_results: [:software_result_parameters])
  end
end
