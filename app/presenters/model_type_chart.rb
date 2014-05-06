class ModelTypeChart < DoughnutChart
  delegate :model_overview_path, to: :@view_context

  def initialize(data_items, view_context)
    @view_context = view_context
    super('Model Type', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.each_with_index.map do |(type, models),index|
      ChartItem.new(
        type, models.count,
        @@color_list[index] || '#666666',
        model_overview_path(ids: models.map{|m| m.genome_model_id}))
    end
  end



end
