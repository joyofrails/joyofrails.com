class SearchesController < ApplicationController
  def show
    @pages = if params[:query].present?
      Page.search(params[:query]).limit(3)
    else
      Page.limit(3)
    end
  end
end
