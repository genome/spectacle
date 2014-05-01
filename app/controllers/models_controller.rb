class ModelsController < ApplicationController
  def overview
    @models = Model.where(id: params[:ids].split('/'))
    raise ActiveRecord::RecordNotFound unless @models.any?

    model_ids = @models.map { |model| model.id }
    statuses = ModelStatusQuery.new(model_ids).execute
    model_types = @models
      .select('model.subclass_name', 'count(model.id) as count')
      .group('model.subclass_name')
    @model_type_chart      = ModelTypeChart.new(model_types)
    @model_status_chart    = ModelStatusChart.new(statuses)

    models_with_status = statuses.each_with_object(@models.each_with_object({}) do |item, hash|
      hash[item.id] = { model: item }
    end) do |status, hash|
      hash[status['model_id']][:status] = status['status']
    end

    @model_status_table    = ModelStatusTable.new(models_with_status)
  end
end
