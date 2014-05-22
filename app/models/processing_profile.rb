class ProcessingProfile < ActiveRecord::Base
  self.table_name = 'model.processing_profile'

  has_many :models, inverse_of: :processing_profile
end
