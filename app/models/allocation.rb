class Allocation < ActiveRecord::Base
  self.table_name = 'disk.allocation'

  def absolute_path
    File.join(mount_path, group_subdirectory, allocation_path)
  end
end
