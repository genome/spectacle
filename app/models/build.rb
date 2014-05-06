class Build < ActiveRecord::Base
  self.table_name = 'model.build'

  has_many :events
  belongs_to :model
  has_one  :master_event, -> {where(event_type: 'genome model build') }, class_name: :Event

  def status
    self.master_event.event_status
  end
end
