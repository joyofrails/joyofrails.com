class TopicsController < ApplicationController
  def index
    @topics = Topic.approved.with_pages.order(name: :asc)
  end

  def show
    @topics = Topic.approved.with_pages.order(name: :asc)
    @topic = Topic.find_by!(slug: params[:slug])
  end
end
