class AnalysisProjectFilter
  include ModelFilter

  def self.filter(rel, val)
    rel.joins(:analysis_project_model_bridges)
      .where(analysis_project_model_bridge: { analysis_project_id: val })
  end

  def self.param
    :analysis_project_id
  end
end
