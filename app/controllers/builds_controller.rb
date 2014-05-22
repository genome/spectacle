class BuildsController < ApplicationController
  def status
    @build = Build.where(build_id: params[:id]).first!
    @model = @build.model
  end
end
