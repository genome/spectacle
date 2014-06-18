class ModelsController < ApplicationController
  def overview
    @models = ModelFilter.filter_query(Model.where(true), params)
    base_query_params = params.slice(*ModelFilter.filterable_params)

    raise ActiveRecord::RecordNotFound unless @models.any?

    models_by_type = @models.group_by(&:subclass_name)
    statuses = ModelStatusQuery.new( @models.pluck(:genome_model_id) ).execute
    @table_items = @models.page(params[:page])

    model_status_hash = @table_items.each_with_object({}) do |item, hash|
      hash[item.id] = { model: item }
    end

    models_with_status = statuses.each_with_object(model_status_hash) do |status, hash|
      hash[status['model_id']][:status] = status['status'] if hash.has_key?(status['model_id'])
    end

    @model_type_chart = ModelTypeChart.new(models_by_type, base_query_params, view_context)
    @model_status_chart = ModelStatusChart.new(statuses, base_query_params, view_context)
    @model_status_table = ModelStatusTable.new(models_with_status, view_context)
  rescue InvalidQueryError => error
    return render text: error.message, status: 422
  end

  def status
    @model = Model.with_statuses_scope.where(genome_model_id: params[:id]).first!
    builds = @model.builds

    @analysis_project = @model.analysis_projects.first

    @build_status_chart    = BuildStatusChart.new(builds)

    @table_items = builds.page(params[:page])
    @build_status_table    = BuildStatusTable.new(@table_items, view_context)
  end
end
