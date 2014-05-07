class SoftwareResultInput < ActiveRecord::Base
  self.table_name = 'result.input'

  belongs_to :software_result
end
