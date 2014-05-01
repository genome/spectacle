class ModelsController < ApplicationController
  def overview
    @models = Model.where(id: params[:ids].split('/'))
    model_ids = @models.map { |model| model.id }
    statuses = ModelStatusQuery.new(model_ids).execute
    model_types = @models
      .select('model.subclass_name', 'count(model.id) as count')
      .group('model.subclass_name')
    @model_type_chart      = ModelTypeChart.new(model_types)
    @model_status_chart    = ModelStatusChart.new(statuses)
  end
end
