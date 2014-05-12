class ModelGroupBridge < ActiveRecord::Base
  self.table_name = 'model.model_group_bridge'

  belongs_to :model
  belongs_to :model_group
end
