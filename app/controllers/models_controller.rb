class ModelsController < ApplicationController
  def overview
    @models = find_models(params)
    raise ActiveRecord::RecordNotFound unless @models.any?

    base_query_params = params.slice(:genome_model_id, :subclass_name, :analysis_project_id, :status, :model_group_id)

    statuses = ModelStatusQuery.new( @models.map(&:genome_model_id) ).execute
    models_by_type = @models.group_by(&:subclass_name)

    @model_type_chart      = ModelTypeChart.new(models_by_type, base_query_params, view_context)
    @model_status_chart    = ModelStatusChart.new(statuses, base_query_params, view_context)

    @table_items = @models.page(params[:page])
    models_with_status = statuses.each_with_object(@table_items.each_with_object({}) do |item, hash|
      hash[item.id] = { model: item }
    end) do |status, hash|
      hash[status['model_id']][:status] = status['status'] if hash.has_key?(status['model_id'])
    end

    @model_status_table    = ModelStatusTable.new(models_with_status, view_context())
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

  private
  def find_models(params)
    query = params.slice(:genome_model_id, :subclass_name)

    models = Model.where(query)
    unless params[:analysis_project_id].blank?
      models = models.joins(:analysis_project_model_bridges).where(analysis_project_model_bridge: { analysis_project_id: params[:analysis_project_id] })
    end
    unless params[:model_group_id].blank?
      models = models.joins(:model_group_bridges).where(model_group_bridge: { model_group_id: params[:model_group_id] })
    end
    unless params[:status].blank?
      if params[:analysis_project_id].blank? and params[:genome_model_id].blank? and params[:model_group_id].blank?
        raise InvalidQueryError.new "Query by status requires additional filtering!"
      end

      raise ActiveRecord::RecordNotFound unless models.any?
      model_ids = models.pluck(:genome_model_id)
      statuses = ModelStatusQuery.new(model_ids).execute
      statuses = statuses.select { |x| x['status'] == params[:status] }
      models = Model.where(genome_model_id: statuses.map { |x| x['model_id'] })
    end

    models
  end
end
