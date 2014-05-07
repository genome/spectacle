class AlignmentMetricsQuery
  def initialize(model_ids, aligner)
    @merged_results_query = merged_alignment_results(builds_query(model_ids))
    @aligner = aligner
  end

  def execute
    results = ActiveRecord::Base.connection.execute(query).values
    software_results = SoftwareResult.where(id: results.map(&:first))
      .includes(:software_result_metrics)
      .group_by(&:id)

    results.inject({}) do |h, result|
      h[result.last] = software_results[result.first].first.software_result_metrics.inject({}) do |ih, metric| 
        ih[metric.metric_name] = metric.metric_value; ih
      end
      h
    end
  end

  private
  def query
    %{
      SELECT software_result.id AS result_id, result.input.input_value AS instrument_data_id
        FROM result.software_result
        INNER JOIN result.user ON result.user.software_result_id = result.software_result.id
        INNER JOIN result.param ON result.param.software_result_id = result.software_result.id
        INNER JOIN result.input ON result.input.software_result_id = result.software_result.id
        WHERE result.user.user_id IN (#{@merged_results_query}) AND
              result.param.param_name = 'aligner_name' AND
              result.param.param_value = '#{@aligner}' AND
              result.software_result.class_name LIKE 'Genome::InstrumentData::AlignmentResult%' AND
              result.input.input_name = 'instrument_data_id';
    }
  end

  def merged_alignment_results(build_ids)
    %{
      SELECT result.software_result.id
        FROM result.software_result
        INNER JOIN result.user ON result.software_result.id = result.user.software_result_id
        WHERE result.software_result.class_name = 'Genome::InstrumentData::AlignmentResult::Merged' AND
              result.user.user_id IN (#{build_ids})
    }
  end

  def builds_query(model_ids)
    in_clause = ActiveRecord::Base.send(:sanitize_sql_array, ['model.build.model_id IN (?)', model_ids])
    %{
      SELECT model.build.build_id FROM model.build WHERE #{in_clause}
    }
  end
end
