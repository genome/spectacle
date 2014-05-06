class ModelStatusTable < StatusTable
  delegate :model_status_path, to: :@view_context

  def initialize(models_with_status, view_context)
    @view_context = view_context
    super('Model Status', get_table_items(models_with_status))
  end

  private
  def get_table_items(models_with_status)
    models_with_status.map do |id, data|
      StatusTableItem.new(id, data[:model].name, model_status_path(id: id), data[:status])
    end
  end
end
