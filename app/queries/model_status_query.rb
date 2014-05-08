class ModelStatusQuery
  def initialize(model_ids)
    @query = build_query(Array(model_ids))
  end

  def execute
    ActiveRecord::Base.connection.execute(@query)
  end

  private
  def build_query(model_ids)
    first_in_clause = ActiveRecord::Base.send(:sanitize_sql_array, ['build.model_id IN (?)', model_ids])
    second_in_clause = ActiveRecord::Base.send(:sanitize_sql_array, ['model.genome_model_id IN (?)', model_ids])
    query(first_in_clause, second_in_clause)
  end

  def query(first_in_clause, second_in_clause)
    %{
      SELECT
        CASE WHEN model.build_requested THEN 'Build Requested'
          WHEN build.status IS NULL THEN 'Buildless'
          ELSE build.status
        END AS status,
        model.genome_model_id AS model_id
      FROM model.model model
      LEFT JOIN (SELECT model_id, MAX(date_scheduled) AS date_scheduled
                  FROM model.build
                  WHERE status != 'Abandoned'
                    AND #{first_in_clause}
                  GROUP BY model_id) date_scheduled
        ON model.genome_model_id = date_scheduled.model_id
      LEFT JOIN model.build build ON model.genome_model_id = build.model_id
        AND date_scheduled.date_scheduled = build.date_scheduled
      WHERE #{second_in_clause};
    }
  end
end
