class Examples::PostsController < ApplicationController
  def index
    post = Examples::Post.new(postable: build_postable)

    render Examples::Posts::IndexView.new(post: post)
  end

  def create
    if params[:commit] == "Refresh"
      post_params = params.require(:examples_post).permit(:title)
      post = Examples::Post.new(post_params) do |p|
        p.postable = build_postable
      end
      Rails.logger.info("Post: #{post.inspect}")
      return render Examples::Posts::IndexView.new(post: post), status: :unprocessable_entity
    end

    post = Examples::Post.new(post_create_params)

    if post.save
      redirect_to :index
    else
      render Examples::Posts::IndexView.new(post: post), status: :unprocessable_entity
    end
  end

  private

  def post_create_params
    postable_attributes = (params.dig(:examples_post, :postable_type) == "Examples::Posts::Markdown") ? [:body] : [:url]
    params.require(:examples_post).permit(:title, :postable_type, postable_attributes: postable_attributes)
  end

  def build_postable
    case params[:type]
    when "link"
      Examples::Posts::Link.new
    when "image"
      Examples::Posts::Image.new
    else
      Examples::Posts::Markdown.new
    end
  end
end
