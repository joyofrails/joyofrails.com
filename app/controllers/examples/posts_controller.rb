class Examples::PostsController < ApplicationController
  def index
    postable = case params[:type]
    when "link"
      Examples::Posts::Link.new
    when "image"
      Examples::Posts::Image.new
    else
      Examples::Posts::Markdown.new
    end

    post = Examples::Post.new(postable: postable)

    render Examples::Posts::IndexView.new(post: post)
  end

  def create
    raise params.inspect
  end
end
