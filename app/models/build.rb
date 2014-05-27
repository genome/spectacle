class Build < ActiveRecord::Base
  self.table_name = 'model.build'
  self.primary_key = 'build_id'

  has_many :events
  has_many :software_result_users, foreign_key: :user_id
  has_many :software_results, through: :software_result_users
  has_many :software_result_metrics, through: :software_results
  has_many :build_metrics
  has_many :build_inputs, inverse_of: :build
  belongs_to :model, inverse_of: :builds

  def this_is_clearly_in_the_wrong_place
    m = self.coverage_metrics_hash  
    theoretical_max_enrichment_factor  = (100 / ((m['target_total_bp'].metric_value.to_f / m['genome_total_bp'].metric_value.to_f) * 100)).round(1)
    alignment_v1_unique_on_target_enrichment_factor = (((m['alignment-wingspan_0_unique_target_aligned_bp'].metric_value.to_f / (m['alignment-wingspan_0_total_aligned_bp'].metric_value.to_f + m['alignment-wingspan_0_total_unaligned_bp'].metric_value.to_f)) * 100) / ((m['target_total_bp'].metric_value.to_f / m['genome_total_bp'].metric_value.to_f) * 100)).round(1) 
    alignemnt_v1_total_on_target_enrichment_factor  = ((((m['alignment-wingspan_0_unique_target_aligned_bp'].metric_value.to_f + m['alignment-wingspan_0_duplicate_target_aligned_bp'].metric_value.to_f) / (m['alignment-wingspan_0_total_aligned_bp'].metric_value.to_f + m['alignment-wingspan_0_total_unaligned_bp'].metric_value.to_f)) * 100) / ((m['target_total_bp'].metric_value.to_f / m['genome_total_bp'].metric_value.to_f) * 100)).round(1)
    alignment_v2_unique_on_target_enrichment_factor = (((m['alignment-v2-wingspan_0_unique_target_aligned_bp'].metric_value.to_f / (m['alignment-v2-wingspan_0_total_aligned_bp'].metric_value.to_f + m['alignment-v2-wingspan_0_total_unaligned_bp'].metric_value.to_f)) * 100) / ((m['target_total_bp'].metric_value.to_f / m['genome_total_bp'].metric_value.to_f) * 100)).round(1) 
    alignemnt_v2_total_on_target_enrichment_factor  = ((((m['alignment-v2-wingspan_0_unique_target_aligned_bp'].metric_value.to_f + m['alignment-v2-wingspan_0_duplicate_target_aligned_bp'].metric_value.to_f) / (m['alignment-v2-wingspan_0_total_aligned_bp'].metric_value.to_f + m['alignment-v2-wingspan_0_total_unaligned_bp'].metric_value.to_f)) * 100) / ((m['target_total_bp'].metric_value.to_f / m['genome_total_bp'].metric_value.to_f) * 100)).round(1)
  end

  def coverage_metrics_hash
    Hash[self.coverage_metrics.collect{|m| [m.metric_name, m]}]
  end

  def coverage_metrics
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

  def coverage_software_results
    class_names = [
      'Genome::InstrumentData::AlignmentResult::Merged::CoverageStats',
      'Genome::InstrumentData::AlignmentResult::Merged::RefCov',
    ]
    software_results.select{|r| class_names.include?(r.class_name)}
  end

  def coverage_minimum_depths
    self.coverage_software_results.map{|r| r.software_result_parameters}.flatten.select{|p| p.name == 'minimum_depths'}
  end

end
