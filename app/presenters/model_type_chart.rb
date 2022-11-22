class ModelTypeChart < DoughnutChart
  delegate :model_overview_path, to: :@view_context

  def initialize(data_items, base_query_params, view_context)
    @view_context = view_context
    @base_query_params = base_query_params

    if @base_query_params.respond_to?(:permit)
      @base_query_params.permit!
    end

    super('Model Type', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.each_with_index.map do |(type, models),index|
      ChartItem.new(
        type, models.count,
        @@color_list[index] || '#666666',
        model_overview_path(@base_query_params.merge({subclass_name: type}))
      )
    end
  end
end
