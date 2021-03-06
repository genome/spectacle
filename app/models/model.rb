class Model < ActiveRecord::Base
  self.table_name = 'model.model'
  self.primary_key = 'genome_model_id'

  has_many :builds, inverse_of: :model
  has_many :events
  has_many :analysis_project_model_bridges
  has_many :analysis_projects, through: :analysis_project_model_bridges
  has_many :model_group_bridges
  has_many :model_groups, through: :model_group_bridges
  has_many :build_metrics, through: :builds
  belongs_to :subject, inverse_of: :models
  belongs_to :processing_profile, inverse_of: :models

  has_one :last_succeeded_build, -> { where(status: 'Succeeded').order('date_completed DESC') }, class_name: 'Build'

  def status
  end

  def self.with_statuses_scope
    eager_load([:builds])
  end
end
