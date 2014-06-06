class ModelGroupsController < ApplicationController
  def overview
    @model_group = ModelGroup.where(id: params[:id]).first!
    model_ids = @model_group.model_group_bridges.pluck(:model_id)
    statuses = ModelStatusQuery.new(model_ids).execute
    models_by_type = @model_group.models.group_by(&:subclass_name)

    base_query_params = { model_group_id: params[:id] }

    @model_type_chart      = ModelTypeChart.new(models_by_type, base_query_params, view_context)
    @model_status_chart    = ModelStatusChart.new(statuses, base_query_params, view_context)
  end

  def coverage
    @model_group = ModelGroup.eager_load(models: [:last_succeeded_build])
      .where(id: params[:id])
      .first!
    builds = @model_group.models.map{|m| m.last_succeeded_build.id }
    @builds_coverage_summary = {}
    CoverageReport.from_build_ids(builds).map do |coverage_report|
      @builds_coverage_summary[coverage_report.build_id] = coverage_report.coverage_report_metrics
    end
  end
end
