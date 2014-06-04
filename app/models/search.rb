require 'rsolr'

class Search
  def self.search(page,results_per_page,options,view_context)
    solr = RSolr.connect url: ENV['GENOME_SYS_SERVICES_SOLR']
    response = solr.paginate page, results_per_page, 'select', params: options
    Search.new response, view_context
  end

  def results
    @response['response']['docs']
  end

  def result_count
    @response['response']['numFound']
  end

  private
  def initialize(response, view_context)
    @response = response

    self.results.each do |doc|
      doc['url'] = url_for_result(doc, view_context)
    end
  end

  def url_for_result(result, view_context)
    object_id = result['object_id']

    case result['type']
    when 'processing_profile'
      view_context.processing_profile_overview_path id: object_id
    when /^model(?: |$)/
      view_context.model_status_path id: object_id
    when 'build'
      view_context.build_status_path id: object_id
    when 'modelgroup'
      view_context.model_group_overview_path id: object_id
    when 'analysis_project'
      view_context.analysis_project_overview_path id: object_id
    when 'wiki-page'
      result['display_url0']
    when 'mail'
      result['display_url0']
    else
      '#'
    end
  end
end
