class AnalysisProjectsController < ApplicationController
  def overview
    @analysis_project = AnalysisProject.find(params[:id])
    inst_data_bridges = @analysis_project.instrument_data_analysis_project_bridges
      .select('status, count(instrument_data_analysis_project_bridge.id) as count')
      .group('status')

    model_ids = @analysis_project.analysis_project_model_bridges.pluck(:model_id)
    statuses = ModelStatusQuery.new(model_ids).execute
    model_types = @analysis_project.models
      .select('model.subclass_name', 'count(model.id) as count')
      .group('model.subclass_name')

    @model_type_chart      = ModelTypeChart.new(model_types)
    @model_status_chart    = ModelStatusAreaChart.new(statuses)
    @config_presenter      = AnalysisProjectConfigPresenter.new(@analysis_project)
    @instrument_data_chart = InstrumentDataAreaChart.new(inst_data_bridges)
  end
end
