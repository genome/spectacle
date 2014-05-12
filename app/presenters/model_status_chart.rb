class ModelStatusChart < DoughnutChart
  delegate :model_overview_path, to: :@view_context

  def initialize(data_items, base_query_params, view_context)
    @view_context = view_context
    @base_query_params = base_query_params
    super('Model Status', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.group_by { |i| i['status'] }
      .map { |status, items| ChartItem.new(status, items.count, @@status_list[status], model_overview_path(@base_query_params.merge({status: status}))) }
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
