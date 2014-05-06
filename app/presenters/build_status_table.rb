class BuildStatusTable < StatusTable
  def initialize(builds)
    super('Build Status', get_table_items(builds))
  end

  private
  def get_table_items(builds)
    builds.map do |build|
      StatusTableItem.new(build.id, 'Build', '#', build.status)
    end #TODO fill in a URI once we have a model page #TODO fill in a "name" column
  end
end
