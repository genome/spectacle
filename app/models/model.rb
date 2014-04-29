class Model < ActiveRecord::Base
  self.table_name = 'model.model'

  has_many :builds
  has_many :events
  has_many :analysis_project_model_bridges
  has_many :analysis_projects, through: :analysis_project_model_bridges

  def status
  end
end
