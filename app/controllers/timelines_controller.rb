class TimelinesController < ApplicationController
  def analysis_project
    @object = AnalysisProject.find(params[:id])
    @back_link_path = view_context.analysis_project_overview_path(@object)
    paginate_timeline

    render 'show'
  end

  private
  def paginate_timeline
    @events = @object.timeline_events
      .order("updated_at DESC")
      .page(params[:page])
      .per(100)
    @timeline = TimelinePresenter.new(@events)
  end
end
