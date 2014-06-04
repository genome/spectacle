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
    search = Search.search page, RESULTS_PER_PAGE, {q: @query}, view_context
    @results = search.results
    @paginatable_results = Kaminari.paginate_array(@results, total_count: search.result_count).page(page).per(RESULTS_PER_PAGE)
  end
end
