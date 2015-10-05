class AnalysisProjectDiskUsageQuery
  def execute(analysis_project_id)
    analysis_project_id_clause = ActiveRecord::Base.send(:sanitize_sql_array, ["sru.user_id = '%s'", analysis_project_id])
    @query = %{SELECT SUM(da.kilobytes_requested / counts.num_users) usage
      FROM result."user" sru
      INNER JOIN result.software_result sr ON sr.id = sru.software_result_id
      INNER JOIN (
      SELECT sr.id software_result_id, COUNT(sru.user_id) num_users FROM result.software_result sr
      INNER JOIN result."user" sru ON sr.id = sru.software_result_id
      WHERE sru.label = 'sponsor'
      AND #{analysis_project_id_clause}
      GROUP BY sr.id
      )  counts ON sr.id = counts.software_result_id
      INNER JOIN disk.allocation da ON da.owner_id = sr.id;}      
    ActiveRecord::Base.connection.execute(@query)
  end 
end