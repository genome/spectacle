class AnalysisProject < ActiveRecord::Base
  self.table_name = 'config.analysis_project'

  has_many :config_profile_items
  has_many :analysis_project_model_bridges
  has_many :instrument_data_analysis_project_bridges
  has_many :models, through: :analysis_project_model_bridges
  has_many :instrument_data, through: :instrument_data_analysis_project_bridges
  has_many :timeline_events, foreign_key: 'object_id'
end
