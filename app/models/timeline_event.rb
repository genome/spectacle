class TimelineEvent < ActiveRecord::Base
  self.table_name = 'timeline.analysis_project'
  belongs_to :analysis_project, foreign_key: :object_id 

end
