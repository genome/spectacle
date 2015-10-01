class DisksController < ApplicationController
  def overview
    @disk_group_sum = Allocation.group(:disk_group_name).order('sum_tb_requested DESC').select('sum(kilobytes_requested)/1024/1024/1024 as sum_tb_requested, disk_group_name').each_with_object({}) { |dg, h| h[dg.disk_group_name] = dg.sum_tb_requested.to_i }
    @owner_class_sum = Allocation.limit(10).group(:owner_class_name).order('sum_tb_requested DESC').select('sum(kilobytes_requested)/1024/1024/1024 as sum_tb_requested, owner_class_name').each_with_object({}) { |oc, h| h[oc.owner_class_name] = oc.sum_tb_requested.to_i }
    @owner_class_sum_rename = @owner_class_sum.each_with_object({}) { |(key, val), new_hash| new_hash[key.split(/::/,3).last] = val }
    @disk_group_status_sum = Allocation.limit(16).group(:status,:disk_group_name).order('sum_kilobytes_requested DESC').sum(:kilobytes_requested).each_with_object({}) {|(key, val), new_hash | new_hash[key] = (val/1024/1024/1024).to_i}    
  end
end
