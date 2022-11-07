class ModelStatusFilter
  include ModelFilter

  def self.filter(rel, val)
    if rel.values.empty?
      raise InvalidQueryError.new 'Find by status requires additional filtering!'
    end
    filtered_model_ids = rel.pluck(:genome_model_id)
    model_ids_with_status = ModelStatusQuery.new(filtered_model_ids, val).execute
    Model.where(genome_model_id: model_ids_with_status.map { |m| m['model_id'] })
  end

  def self.param
    :status
  end
end
