class StatusTable
  attr_reader :name
  attr_reader :items

  def initialize(table_name, items)
    @name = table_name
    @items = items
  end
end

class StatusTableItem < Struct.new(:id, :name, :status, :uri)
end
