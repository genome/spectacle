class ProcessingProfileFilter
  include ModelFilter

  def self.filter(rel, val)
    rel.where(processing_profile_id: val)
  end

  def self.param
    :processing_profile_id
  end
end
