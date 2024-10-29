class SearchesController < ApplicationController
  def show
    query = params[:query] || ""
    pages = if query.present?
      Page.search(query).limit(3)
    else
      Page.limit(3)
    end

    render Searches::ShowView.new(pages:, query:)
  end
end
