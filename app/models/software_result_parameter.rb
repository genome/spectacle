class SoftwareResultParameter < ActiveRecord::Base
  self.table_name = 'result.param'

  belongs_to :software_result
end
