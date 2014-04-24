class Event < ActiveRecord::Base
  self.table_name = 'model.event'
  self.primary_key = 'genome_model_event_id'

  belongs_to :build
  belongs_to :model
end
