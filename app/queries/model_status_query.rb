class ModelStatusQuery
  def initialize(model_ids, statuses = [])
    @query = build_query(Array(model_ids), Array(statuses))
  end

  def execute
    ActiveRecord::Base.connection.execute(@query)
  end

  private
  def build_query(model_ids, statuses)
    first_in_clause = ActiveRecord::Base.send(:sanitize_sql_array, ['build.model_id IN (?)', model_ids])
    second_in_clause = ActiveRecord::Base.send(:sanitize_sql_array, ['model.genome_model_id IN (?)', model_ids])
    status_clause = if statuses.empty?
                      '1=1'
                    else
                      ActiveRecord::Base.send(:sanitize_sql_array, ['status IN (?)', statuses])
                    end

    base_query(first_in_clause, second_in_clause, status_clause)
  end

  def base_query(first_in_clause, second_in_clause, status_clause)
    %{
      SELECT
        CASE WHEN model.build_requested THEN 'Build Requested'
          WHEN build.status IS NULL THEN 'Buildless'
          ELSE build.status
        END AS status,
        model.genome_model_id AS model_id
      FROM model.model model
      LEFT JOIN (
        SELECT ROW_NUMBER() OVER (PARTITION BY model_id ORDER BY created_at DESC) AS r, model_id, status
        FROM model.build
        WHERE status != 'Abandoned'
        AND #{first_in_clause}
      ) build
        ON model.genome_model_id = build.model_id
      WHERE #{second_in_clause}
      AND (build.r = 1 OR build.r IS NULL)
      AND #{status_clause};
    }
  end
end
