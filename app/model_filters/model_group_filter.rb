class ModelGroupFilter
  include ModelFilter

  def self.filter(rel, val)
    rel.joins(:model_group_bridges)
      .where(model_group_bridge: { model_group_id: val })
  end

  def self.param
    :model_group_id
  end
end
