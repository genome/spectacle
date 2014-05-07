class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def blah
    ap = AnalysisProject.find(params[:analysis_project_id])
    render json: AlignmentMetricsQuery.new(ap.models.pluck(:id), 'bwa').execute.to_json
  end
end
