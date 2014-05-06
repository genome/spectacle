class ModelStatusChart < DoughnutChart
  delegate :model_overview_path, to: :@view_context

  def initialize(data_items, view_context)
    @view_context = view_context
    super('Model Status', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.group_by { |i| i['status'] }
      .map { |status, items| ChartItem.new(status, items.count, @@status_list[status], model_overview_path(ids: items.map {|i| i['model_id'] } )) }
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
