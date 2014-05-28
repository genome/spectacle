require 'rsolr'

class SearchController < ApplicationController
  def overview
  end

  def results
    @query = params[:query]
    unless @query
      redirect_to search_overview_path, status: 303
    end
    solr = RSolr.connect url: ENV['GENOME_SYS_SERVICES_SOLR']
    response = solr.get 'select', params: {q: @query}
    @results = response['response']['docs']
    @results.each do |doc|
      doc['url'] = url_for_result(doc)
    end
  end


  private
  def url_for_result(result)
    object_id = result['object_id']

    case result['type']
    when 'processing_profile'
      processing_profile_overview_path id: object_id
    when /^model(?: |$)/
      model_status_path id: object_id
    when 'build'
      build_status_path id: object_id
    when 'modelgroup'
      model_group_overview_path id: object_id
    when 'analysis_project'
      analysis_project_overview_path id: object_id
    when 'wiki-page'
      result['display_url0']
    when 'email'
      result['display_url0']
    else
      '#'
    end
  end
end
