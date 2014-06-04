require 'rsolr'

class SearchController < ApplicationController
  def overview
  end

  RESULTS_PER_PAGE = 25
  def results
    @query = params[:query]
    unless @query
      redirect_to search_overview_path, status: 303
    end

    page = params[:page] || 1
    solr = RSolr.connect url: ENV['GENOME_SYS_SERVICES_SOLR']
    response = solr.paginate page, RESULTS_PER_PAGE, 'select', params: {q: @query}

    @results = response['response']['docs']
    @results.each do |doc|
      doc['url'] = url_for_result(doc)
    end

    @paginatable_results = Kaminari.paginate_array(@results, total_count: response['response']['numFound']).page(page).per(RESULTS_PER_PAGE)
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
    when 'mail'
      result['display_url0']
    else
      '#'
    end
  end
end
