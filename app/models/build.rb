class Build < ActiveRecord::Base
  self.table_name = 'model.build'

  has_many :events
  belongs_to :model
end
