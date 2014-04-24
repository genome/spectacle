class InstrumentDataAnalysisProjectBridge < ActiveRecord::Base
  self.table_name = 'config.instrument_data_analysis_project_bridge'

  belongs_to :analysis_project
  belongs_to :instrument_data
end
