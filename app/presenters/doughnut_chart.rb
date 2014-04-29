class DoughnutChart
  attr_reader :name
  attr_reader :items

  @@color_list = [
    '#883333',
    '#338833',
    '#333388',
    '#888833',
    '#883388',
    '#338888',
    '#333333',
    '#888888'
  ]

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

  def self.color_map(list)
    list.each_with_index.inject({}) do |hash, (item, index)|
      hash[item] = @@color_list[index]
      hash
    end
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
