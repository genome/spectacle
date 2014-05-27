class Subject < ActiveRecord::Base
  self.table_name = 'subject.subject'
  self.primary_key = 'subject_id'

  has_many :model, inverse_of: :subject
end
