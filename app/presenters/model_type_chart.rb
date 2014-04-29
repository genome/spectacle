class ModelTypeChart < DoughnutChart
  def initialize(data_items)
    super('Model Type', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.map { |item| ChartItem.new(item.subclass_name, item.count, "33CC33") }
  end

  @@color_map = {
    'Failed'          => '#FF0000',
    'Succeeded'       => '#33CC33',
    'Buildless'       => '#3366FF',
    'Build Requested' => '#FFFF00',
  }
end
