class ModelTypeChart < DoughnutChart
  def initialize(data_items)
    super('Model Type', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.each_with_index.map { |item,index| ChartItem.new(item.subclass_name, item.count, @@color_list[index] || '#666666') }
  end



end
