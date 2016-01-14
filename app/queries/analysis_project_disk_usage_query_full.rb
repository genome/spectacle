class AnalysisProjectDiskUsageQueryFull
  def initialize
    @query = %{SELECT sru.user_id,SUM(da.kilobytes_requested / counts.num_users) usage
      FROM result."user" sru
      INNER JOIN result.software_result sr ON sr.id = sru.software_result_id
      INNER JOIN (
      SELECT sr.id software_result_id, COUNT(sru.user_id) num_users FROM result.software_result sr
      INNER JOIN result."user" sru ON sr.id = sru.software_result_id
      WHERE sru.label = 'sponsor'
      GROUP BY sr.id
      )  counts ON sr.id = counts.software_result_id
      INNER JOIN disk.allocation da ON da.owner_id = sr.id
      WHERE da.status = 'active'
      GROUP BY sru.user_id      
      ORDER BY usage DESC;}
  end
  def execute
    ActiveRecord::Base.connection.execute(@query)
  end 
end