# frozen_string_literal: true

class Examples::Posts::IndexView < ApplicationView
  include Phlex::Rails::Helpers::ClassNames
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::TurboRefreshesWith

  def initialize(posts:)
    @posts = posts
  end

  def view_template
    render Pages::Header.new(
      title: "Examples: Posts",
      description: "This is an example for creating a post of different types, like text, link, or image."
    )

    div(class: "section-content container py-gap") do
      link_to "New Post", new_examples_post_path, class: "button primary", data: {turbo_frame: "examples_post_form"}

      turbo_frame_tag :examples_post_form

      turbo_frame_tag :examples_posts, refresh: "morph" do
        if @posts.empty?
          div do
            p { "Nothing has been posted yet!" }
          end
        end
        @posts.each do |post|
          div do
            h2 { post.title }
            case post.postable
            when Examples::Posts::Link
              a(href: post.postable.url, rel: "noopener noreferrer", target: "_blank") { post.postable.url }
            when Examples::Posts::Image
              img(src: post.postable.url, alt: post.title)
            when Examples::Posts::Markdown
              markdown(post.postable.body)
            end
          end
        end
      end
    end
  end

  def markdown(content)
    render Markdown::Base.new(content)
  end
end
