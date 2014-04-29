class ConfigProfileItem < ActiveRecord::Base
  self.table_name = 'config.profile_item'

  belongs_to :analysis_project
  belongs_to :analysis_menu_item, foreign_key: :analysismenu_item_id
  has_one :allocation, foreign_key: :owner_id

  def file_path
    if concrete?
      files = Dir.glob(File.join(allocation.absolute_path, '*'))
      raise "More than one file found at #{allocation.absolute_path}" if files.size >1
      files.first
    else
      analysis_menu_item.file_path
    end
  end

  def concrete?
    !allocation.nil?
  end
end
