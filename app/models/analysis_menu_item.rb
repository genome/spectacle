class AnalysisMenuItem < ActiveRecord::Base
  self.table_name = 'config.analysismenu_item'
  has_many :config_profile_items
end
