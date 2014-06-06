class Build < ActiveRecord::Base
  self.table_name = 'model.build'
  self.primary_key = 'build_id'

  has_many :events
  has_many :software_result_users, foreign_key: :user_id
  has_many :software_results, through: :software_result_users
  has_many :coverage_software_results, -> { where(class_name: CoverageReport.coverage_result_class_names) }, through: :software_result_users, source: :software_result

  has_many :software_result_metrics, through: :software_results
  has_many :enrichment_metrics, -> { where(metric_name: CoverageReport.enrichment_metric_names) }, through: :software_results, source: :software_result_metrics
  has_many :alignment_summary_metrics, -> { where(metric_name: CoverageReport.alignment_summary_metric_names) }, through: :software_results, source: :software_result_metrics

  has_many :build_metrics
  has_many :build_inputs, inverse_of: :build
  belongs_to :model, inverse_of: :builds
end
