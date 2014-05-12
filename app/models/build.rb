class Build < ActiveRecord::Base
  self.table_name = 'model.build'

  has_many :events
  has_many :software_result_users, foreign_key: :user_id
  has_many :software_results, through: :software_result_users
  belongs_to :model
end
