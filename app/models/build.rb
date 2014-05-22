class Build < ActiveRecord::Base
  self.table_name = 'model.build'
  self.primary_key = 'build_id'

  has_many :events
  has_many :software_result_users, foreign_key: :user_id
  has_many :software_results, through: :software_result_users
  has_many :build_metrics
  has_many :build_inputs

  belongs_to :model, inverse_of: :builds
end
