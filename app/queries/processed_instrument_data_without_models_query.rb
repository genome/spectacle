class ProcessedInstrumentDataWithoutModelsQuery
  def initialize(analysis_project_id)
    @query = build_query(analysis_project_id)
  end

  def execute
    ActiveRecord::Base.connection.execute(@query)
  end

  private
  def build_query(analysis_project_id)
    analysis_project_id_clause = ActiveRecord::Base.send(:sanitize_sql_array, ["analysis_project_id = '%s'", analysis_project_id])
    %{
      SELECT instrument_data_id
      FROM config.instrument_data_analysis_project_bridge
      WHERE #{analysis_project_id_clause}
        AND status = 'processed'
        AND instrument_data_id NOT IN (SELECT DISTINCT(value_id)
          FROM model.model_input
          INNER JOIN config.analysis_project_model_bridge anp_bridge ON anp_bridge.model_id = model_input.model_id
          WHERE model_input.name = 'instrument_data'
          AND #{analysis_project_id_clause});
    }
  end
end
