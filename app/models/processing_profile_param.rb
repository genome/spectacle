class ProcessingProfileParam < ActiveRecord::Base
  self.table_name = 'model.processing_profile_param'

  belongs_to :processing_profile, inverse_of: :processing_profile_params
end
