class InstrumentDataChart < DoughnutChart
  def initialize(data_items)
    super('Instrument Data Status', get_chart_items(data_items))
  end

  private
  def get_chart_items(data_items)
    data_items.map do |i|
      ChartItem.new(i.status, i.count, @@color_map[i.status])
    end
  end

  @@color_map = {
    'new'       => '#3366FF',
    'failed'    => '#FF0000',
    'skipped'   => '#FFFF00',
    'processed' => '#33CC33',
  }
end
