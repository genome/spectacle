class BuildInput < ActiveRecord::Base
  self.table_name = 'model.build_input'

  belongs_to :build
end
