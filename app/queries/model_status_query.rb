class ModelStatusQuery
  def initialize(model_ids)
    @query = build_query(Array(model_ids))
  end

  def execute
    ActiveRecord::Base.connection.execute(@query)
  end

  private
  def build_query(model_ids)
    first_in_clause = ActiveRecord::Base.send(:sanitize_sql_array, ['event.model_id IN (?)', model_ids])
    second_in_clause = ActiveRecord::Base.send(:sanitize_sql_array, ['model.genome_model_id IN (?)', model_ids])
    query(first_in_clause, second_in_clause)
  end

  def query(first_in_clause, second_in_clause)
    %{
      SELECT
        CASE WHEN model.build_requested THEN 'Build Requested'
          WHEN event.event_status IS NULL THEN 'Buildless'
          ELSE event.event_status
        END AS status,
        model.genome_model_id AS model_id
      FROM model.model model
      LEFT JOIN (SELECT model_id, MAX(date_scheduled) AS date_scheduled
                  FROM model.event
                  WHERE event_status != 'Abandoned'
                    AND #{first_in_clause}
                    AND event_type = 'genome model build'
                  GROUP BY model_id) date_scheduled
        ON model.genome_model_id = date_scheduled.model_id
      LEFT JOIN model.event event ON model.genome_model_id = event.model_id
        AND date_scheduled.date_scheduled = event.date_scheduled
        AND event.event_type = 'genome model build'
      WHERE #{second_in_clause};
    }
  end
end
