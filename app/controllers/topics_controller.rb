class TopicsController < ApplicationController
  def index
    @topics = Topic.approved.with_pages.order(name: :asc)
    @topics = @topics.where("lower(slug) LIKE ?", "#{params[:letter].downcase}%") if params[:letter].present?
  end

  def show
    @topic = Topic.find_by!(slug: params[:slug])
  end
end
