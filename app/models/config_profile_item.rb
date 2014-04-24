class ConfigProfileItem < ActiveRecord::Base
  self.table_name = 'config.profile_item'

  belongs_to :analysis_project
  belongs_to :analysis_menu_item, foreign_key: :analysismenu_item_id
end
