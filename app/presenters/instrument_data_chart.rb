class InstrumentDataChart < DoughnutChart
  def initialize(data_items)
    super('Instrument Data Status', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.map do |i|
      ChartItem.new(i.status, i.count, @@status_list[i.status])
    end
  end

  @@status_list = color_map([
    'failed',
    'processed',
    'new',
    'skipped'
  ])

end
