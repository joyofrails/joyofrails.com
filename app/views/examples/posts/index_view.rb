# frozen_string_literal: true

class Examples::Posts::IndexView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo

  def initialize(post:)
    @post = post
  end

  def view_template
    render Pages::Header.new(
      title: "Examples: Posts",
      description: "This is an example for creating a post of different types, like text, link, or image."
    )

    div(class: "section-content container py-gap") do
      div(class: "tabs") do
        link_to "Text", examples_posts_path
        link_to "Link", examples_posts_path(type: "link")
        link_to "Image", examples_posts_path(type: "image")
      end

      form_with model: @post, url: examples_posts_path, method: :post do |form|
        fieldset do
          form.label :title
          form.text_field :title, placeholder: "My Post 🎸", required: true
        end

        form.fields_for :postable, @post.postable do |postable_form|
          case @post.postable
          when Examples::Posts::Markdown
            fieldset do
              postable_form.label :body, "Text (Markdown)"
              postable_form.text_area :body, placeholder: "# This is a post about guitars 🎸", required: true
            end
          when Examples::Posts::Link
            fieldset do
              postable_form.label :url, "Link URL"
              postable_form.text_field :url, placeholder: "https://example.com", required: true
            end
          when Examples::Posts::Image
            fieldset do
              postable_form.label :url, "Image URL"
              postable_form.text_field :url, placeholder: "https://example.com/image.jpg", required: true
            end
          end
        end

        fieldset do
          form.submit "Save", class: "button primary"
        end
      end
    end
  end
end
