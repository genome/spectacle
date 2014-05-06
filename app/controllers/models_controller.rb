class ModelsController < ApplicationController
  def overview
    @models = Model.where(id: params[:ids].split('/'))
    raise ActiveRecord::RecordNotFound unless @models.any?

    model_ids = @models.map { |model| model.id }
    statuses = ModelStatusQuery.new(model_ids).execute
    models_by_type = @models.group_by(&:subclass_name)

    @model_type_chart      = ModelTypeChart.new(models_by_type, view_context)
    @model_status_chart    = ModelStatusChart.new(statuses, view_context)

    models_with_status = statuses.each_with_object(@models.each_with_object({}) do |item, hash|
      hash[item.id] = { model: item }
    end) do |status, hash|
      hash[status['model_id']][:status] = status['status']
    end

    @model_status_table    = ModelStatusTable.new(models_with_status, view_context())
  end

  def status
    @model = Model.with_statuses_scope.where(id: params[:id]).first!
    builds = @model.builds

    @build_status_chart    = BuildStatusChart.new(builds)
    @build_status_table    = BuildStatusTable.new(builds)
  end
end
