class SoftwareResultUser < ActiveRecord::Base
  self.table_name = 'result.user'

  belongs_to :software_result
  belongs_to :build, foreign_key: :user_id
end
