class SubjectAttribute < ActiveRecord::Base
  self.table_name = 'subject.subject_attribute'

  belongs_to :subject, inverse_of: :subject_attributes
end
