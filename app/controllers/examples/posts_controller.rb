class Examples::PostsController < ApplicationController
  def index
    render Examples::Posts::IndexView.new(posts: Examples::Post.limit(25).order(created_at: :desc))
  end

  def new
    post = Examples::Post.new(post_params_permitted)

    render Examples::Posts::NewView.new(post: post)
  end

  def create
    post = Examples::Post.new(post_params_permitted)

    if post.save
      redirect_to examples_posts_path
    else
      render Examples::Posts::NewView.new(post: post), status: :unprocessable_entity
    end
  end

  private

  def post_params = params.fetch(:examples_post, {})

  def post_params_permitted
    post_params.permit(:title, :postable_type, link_attributes: [:url], image_attributes: [:url], markdown_attributes: [:body])
  end
end
