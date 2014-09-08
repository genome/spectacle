class Tag < ActiveRecord::Base
  self.table_name = 'config.tag'

  has_many :tag_config_profile_item_bridges
  has_many :config_profile_items, through: :tag_config_profile_item_bridges
end
