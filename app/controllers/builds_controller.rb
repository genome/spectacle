class BuildsController < ApplicationController
  def overview
    @build = Build.where(build_id: params[:id]).first!
    @model = @build.model
  end
end
