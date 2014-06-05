class SubjectsController < ApplicationController
  def overview
    @subject = Subject.where(:subject_id => params[:id]).first!
    @attributes = @subject.subject_attributes
    @models = @subject.models.page(params[:page])
    @libraries = @subject.libraries
  end
end
