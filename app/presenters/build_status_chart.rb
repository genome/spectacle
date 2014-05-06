class BuildStatusChart < DoughnutChart
  def initialize(builds)
    super('Build Status', get_chart_items(builds))
  end

  private
  def get_chart_items(builds)
    builds.group_by { |b| b.status }
      .map { |status, items| ChartItem.new(status, items.count, @@status_list[status]) }
  end

  @@status_list = color_map([
    'Failed',
    'Succeeded',
    'Unknown',
    'Running',
    'Unstartable',
    'Abandoned',
    'Scheduled'
  ])

end
