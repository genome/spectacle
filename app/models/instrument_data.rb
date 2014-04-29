class InstrumentData < ActiveRecord::Base
  self.table_name = 'instrument.data'

  has_many :instrument_data_analysis_project_bridges
  has_many :analysis_projects, through: :instrument_data_analysis_project_bridges
end
