class Library < ActiveRecord::Base
  self.table_name = 'instrument.fragment_library'
  self.primary_key = 'library_id'

  has_many :instrument_data, inverse_of: :library

  belongs_to :sample, class_name: 'Subject', inverse_of: :libraries
end
