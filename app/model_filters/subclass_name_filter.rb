class SubclassNameFilter
  include ModelFilter

  def self.filter(rel, val)
    rel.where(subclass_name: val)
  end

  def self.param
    :subclass_name
  end
end
