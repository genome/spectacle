class BuildStatusTable < StatusTable
  delegate :build_status_path, to: :@view_context

  def initialize(builds, view_context)
    @view_context = view_context
    super('Build Status', get_table_items(builds))
  end

  private
  def get_table_items(builds)
    builds.map do |build|
      StatusTableItem.new(build.id, build.model.name, build.status, build_status_path(id: build.build_id))
    end
  end
end
