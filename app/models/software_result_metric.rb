class SoftwareResultMetric < ActiveRecord::Base
  self.table_name = 'result.metric'

  belongs_to :software_result
end
