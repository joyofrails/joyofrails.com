# frozen_string_literal: true

class Examples::Posts::NewView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::ClassNames

  def initialize(post:)
    @post = post
  end

  def view_template
    render Pages::Header.new(
      title: "Examples: New Post",
      description: "This is an example for creating a post of different types, like text, link, or image."
    )

    div(class: "section-content container py-gap mb-3xl") do
      turbo_frame_tag :examples_post_form do
        render Examples::Posts::Form.new(post: @post)
      end
    end
  end
end
