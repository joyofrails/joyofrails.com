# frozen_string_literal: true

class Examples::Posts::Form < ApplicationComponent
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::ClassNames

  def initialize(post:)
    @post = post
    @image = post.image || Examples::Posts::Image.new
    @link = post.link || Examples::Posts::Link.new
    @markdown = post.markdown || Examples::Posts::Markdown.new
    @post.postable ||= @markdown
  end

  def view_template
    form_with model: @post,
      url: examples_posts_path,
      method: :post,
      data: {
        controller: "frame-form",
        action: "turbo:submit-end->frame-form#redirect",
        frame_form_redirect_frame_value: "examples_posts"
      } do |form|
      div(class: "tabs") do
        form.label :postable_type, "Text", value: @markdown.class.name, class: "tab"
        form.radio_button :postable_type, @markdown.class.name, checked: markdown?, data: {action: "change->frame-form#refresh"}
        form.label :postable_type, "Link", value: @link.class.name, class: "tab"
        form.radio_button :postable_type, @link.class.name, checked: link?, data: {action: "frame-form#refresh"}
        form.label :postable_type, "Image", value: @image.class.name, class: "tab"
        form.radio_button :postable_type, @image.class.name, checked: image?, data: {action: "frame-form#refresh"}
      end

      fieldset do
        form.label :title
        form.text_field :title, placeholder: "My Post 🎸", required: false
      end

      form.fields_for :markdown, @markdown do |postable_form|
        fieldset(class: class_names(hidden: !markdown?)) do
          postable_form.label :body, "Text (Markdown)"
          postable_form.text_area :body, placeholder: "# This is a post about guitars 🎸", required: false
        end
      end
      form.fields_for :link, @link do |postable_form|
        fieldset(class: class_names(hidden: !link?)) do
          postable_form.label :url, "Link URL"
          postable_form.text_field :url, placeholder: "https://example.com", required: false
        end
      end
      form.fields_for :image, @image do |postable_form|
        fieldset(class: class_names(hidden: !image?)) do
          postable_form.label :url, "Image URL"
          postable_form.text_field :url, placeholder: "https://example.com/image.jpg", required: false
        end
      end

      fieldset do
        form.submit "Refresh",
          class: "button primary hidden",
          formaction: new_examples_post_path,
          formmethod: "get",
          formnovalidate: true,
          data: {frame_form_target: "refreshButton"}
      end

      fieldset do
        form.submit "Save", class: "button primary"
      end
    end
  end

  private

  def markdown? = @post.postable == @markdown

  def link? = @post.postable == @link

  def image? = @post.postable == @image
end
