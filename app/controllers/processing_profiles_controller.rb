class ProcessingProfilesController < ApplicationController
  def overview
    @processing_profile = ProcessingProfile.where(id: params[:id]).first!
    @params = @processing_profile.processing_profile_params
  end
end
