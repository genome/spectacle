class AnalysisProjectModelBridge < ActiveRecord::Base
  self.table_name = 'config.analysis_project_model_bridge'

  belongs_to :model
  belongs_to :analysis_project
end
