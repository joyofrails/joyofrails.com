class NewslettersController < ApplicationController
  def index
    @newsletters = Newsletter.sent
  end

  def show
    @newsletter = Newsletter.find(params[:id])
  end
end
