class DisksController < ApplicationController
   def overview
    @disk_group_sum = Rails.cache.fetch("disk group sum") do
    Allocation.group(:disk_group_name).order('sum_tb_requested DESC').select('sum(kilobytes_requested)/1024/1024/1024 as sum_tb_requested, disk_group_name').each_with_object({}) { |dg, h| h[dg.disk_group_name] = dg.sum_tb_requested.to_i }
    end
    @owner_class_sum = Rails.cache.fetch("owner class sum") do
    Allocation.limit(10).group(:owner_class_name).order('sum_tb_requested DESC').select('sum(kilobytes_requested)/1024/1024/1024 as sum_tb_requested, owner_class_name').each_with_object({}) { |oc, h| h[oc.owner_class_name] = oc.sum_tb_requested.to_i }
    end
    @owner_class_status_sum = Rails.cache.fetch("owner class status sum") do
    Allocation.limit(16).group(:status,:owner_class_name).order('sum_kilobytes_requested DESC').sum(:kilobytes_requested).each_with_object({}) {|(key, val), new_hash | new_hash[key] = (val/1024/1024/1024).to_i}    
    end
    @owner_class_sum_rename = Rails.cache.fetch("owner class sum rename") do
    @owner_class_sum.each_with_object({}) { |(key, val), new_hash| new_hash[key.split(/::/,3).last] = val }
    end
    @disk_group_status_sum = Rails.cache.fetch("disk group status sum") do
    Allocation.limit(16).group(:status,:disk_group_name).order('sum_kilobytes_requested DESC').sum(:kilobytes_requested).each_with_object({}) {|(key, val), new_hash | new_hash[key] = (val/1024/1024/1024).to_i}    
    end 
    @disk_sponsor_result_hash = Rails.cache.fetch('disk sponsor result hash') do
    hash = {}
    AnalysisProjectDiskUsageQueryTop10.new.execute.each_row { |(id, usage)| hash[id] = usage }; hash
    end
    @disk_sponsor_result_hash_full = Rails.cache.fetch('disk sponsor result hash full') do
    hash = {}
    AnalysisProjectDiskUsageQueryFull.new.execute.each_row { |(id, usage)| hash[id] = usage }; hash
    end
  end
end
