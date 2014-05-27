class BuildInput < ActiveRecord::Base
  self.table_name = 'model.build_input'

  belongs_to :build, inverse_of: :build_inputs
end
