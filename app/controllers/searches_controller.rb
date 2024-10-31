class SearchesController < ApplicationController
  rescue_from Searches::ParseFailed do |error|
    respond_to do |format|
      format.html { render Searches::ShowView.new(pages: [], query: @raw_query) }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("search-results", plain: "No results") }
    end
  end

  def show
    @raw_query = params[:query] || ""
    pages = if @raw_query.present?
      query = Searches::Query.parse!(@raw_query)
      Page.search("#{query}*").with_snippets.ranked.limit(3)
    else
      []
    end

    render Searches::ShowView.new(pages:, query: @raw_query)
  end
end
