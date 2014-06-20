class AnalysisProjectsController < ApplicationController
  def overview
    @analysis_project = AnalysisProject.where(id: params[:id]).first!
    inst_data_bridges = @analysis_project.instrument_data_analysis_project_bridges
      .select('status, count(instrument_data_analysis_project_bridge.id) as count')
      .group('status')

    model_ids = @analysis_project.analysis_project_model_bridges.pluck(:model_id)
    statuses = ModelStatusQuery.new(model_ids).execute
    models_by_type = @analysis_project.models.group_by(&:subclass_name)

    base_query_params = { analysis_project_id: params[:id] }

    @model_type_chart      = ModelTypeChart.new(models_by_type, base_query_params, view_context)
    @model_status_chart    = ModelStatusChart.new(statuses, base_query_params, view_context)
    @config_presenter      = AnalysisProjectConfigPresenter.new(@analysis_project)
    @instrument_data_chart = InstrumentDataChart.new(inst_data_bridges)

    @timeline              = TimelinePresenter.new @analysis_project.timeline_events
                                                     .order("updated_at DESC")
                                                     .limit(25)
  end
end
