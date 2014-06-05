class Subject < ActiveRecord::Base
  self.table_name = 'subject.subject'
  self.primary_key = 'subject_id'

  has_many :models, inverse_of: :subject
  has_many :subject_attributes, inverse_of: :subject
  has_many :libraries, foreign_key: :sample_id, inverse_of: :sample
end
