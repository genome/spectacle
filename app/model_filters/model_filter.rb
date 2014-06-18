module ModelFilter

  def self.included(klass)
    (@model_filters ||= []) << klass
  end

  def self.filterable_params
    @filterable_params  ||= @model_filters.map(&:param)
  end

  def self.model_filters
    #this particular filter has to go last. hardcoded hack :(
    @sorted_model_filters ||= @model_filters.reject { |f| f == ModelStatusFilter } + @model_filters.select { |f| f ==  ModelStatusFilter }
  end

  def self.filter_query(relation, params)
    model_filters.inject(relation) do |rel, filter|
      val = params[filter.param]
      if val.blank?
        rel
      else
        filter.filter(rel, val)
      end
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), '*.rb')).each do |file|
  require file unless file =~ Regexp.new("/#{__FILE__}/")
end
