class BuildMetric < ActiveRecord::Base
  self.table_name = 'model.build_metric'

  belongs_to :build
end
