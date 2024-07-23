class Examples::PostsController < ApplicationController
  def index
    post = Examples::Post.new(post_params_new)

    render Examples::Posts::IndexView.new(post: post)
  end

  def create
    post = Examples::Post.new(post_create_params)

    if post.save
      redirect_to :index
    else
      render Examples::Posts::IndexView.new(post: post), status: :unprocessable_entity
    end
  end

  private

  def post_create_params = params.require(:examples_post, {}).permit(:title)

  def post_params = params.fetch(:examples_post, {})

  def post_params_new
    post_params.permit(:title, :postable_type, link_attributes: [:url], image_attributes: [:url], markdown_attributes: [:body])
  end
end
