class ModelStatusTable < StatusTable
  def initialize(models_with_status)
    super('Model Status', get_table_items(models_with_status))
  end

  private
  def get_table_items(models_with_status)
    models_with_status.map do |id, data|
      StatusTableItem.new(id, data[:model].name, '#', data[:status])
    end #TODO fill in a URI once we have a model page
  end
end
