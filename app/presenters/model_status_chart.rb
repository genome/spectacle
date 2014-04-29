class ModelStatusChart < DoughnutChart
  def initialize(data_items)
    super('Model Status', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.group_by { |i| i['status'] }
      .map { |status, items| ChartItem.new(status, items.count, @@status_list[status]) }
  end

  @@status_list = color_map([
    'Failed',
    'Succeeded',
    'Buildless',
    'Running',
    'Unstartable',
    'Build Requested',
    'Scheduled'
  ])

end
