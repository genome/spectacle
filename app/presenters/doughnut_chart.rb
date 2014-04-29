class DoughnutChart
  attr_reader :name
  attr_reader :items

  def initialize(chart_name, items)
    @name = chart_name
    @items = items
  end

  def total_items
    @total_items ||= items.inject(0) { |sum, i| sum += i.value }
  end

  def chart_id
    @name.parameterize
  end

  def data
    items.map(&:to_chart_item).to_json
  end

  def options
    {
      scaleOverlay: false,
      scaleOverride: true,
      scaleSteps: scale_steps,
      scaleStepWidth: scale_step_width,
      scaleStartValue: 0
    }.to_json
  end

  private
  def scale_steps
    3
  end

  def scale_step_width
    (total_items/scale_steps).to_i + 1
  end
end

class ChartItem < Struct.new(:name, :value, :color)
  def to_chart_item
    {
      value: value,
      color: color
    }
  end
end
