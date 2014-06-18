class GenomeModelFilter
  include ModelFilter

  def filter(rel, val)
    rel.where(genome_model_id: val)
  end

  def self.param
    :genome_model_id
  end
end
