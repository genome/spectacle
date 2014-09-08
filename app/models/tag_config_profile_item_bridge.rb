class TagConfigProfileItemBridge < ActiveRecord::Base
  self.table_name = 'config.tag_profile_item'

  belongs_to :tag
  belongs_to :config_profile_item, foreign_key: :profile_item_id
  belongs_to :analysis_project
end
