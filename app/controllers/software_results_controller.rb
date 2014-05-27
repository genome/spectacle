class SoftwareResultsController < ApplicationController
  def overview
    @software_result = SoftwareResult.where(id: params[:id]).first!
    @inputs = @software_result.software_result_inputs
    @params = @software_result.software_result_parameters
    @metrics = @software_result.software_result_metrics
  end
end
