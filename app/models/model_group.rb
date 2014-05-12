class ModelGroup < ActiveRecord::Base
  self.table_name = 'model.model_group'

  has_many :model_group_bridges
  has_many :models, through: :model_group_bridges
end
