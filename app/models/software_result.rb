class SoftwareResult < ActiveRecord::Base
  self.table_name = 'result.software_result'

  has_many :software_result_inputs
  has_many :software_result_parameters
  has_many :software_result_metrics
  has_many :software_result_users
end
