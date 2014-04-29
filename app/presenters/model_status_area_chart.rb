class ModelStatusAreaChart < PolarAreaChart
  def initialize(data_items)
    super('Model Status', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.group_by { |i| i['status'] }
      .map { |status, items| ChartItem.new(status, items.count, @@color_map[status]) }
  end

  @@color_map = {
    'Failed'          => '#FF0000',
    'Succeeded'       => '#33CC33',
    'Buildless'       => '#3366FF',
    'Build Requested' => '#FFFF00',
    'Unstartable'     => '#000000',
  }
end
