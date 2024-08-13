# frozen_string_literal: true

class Settings::ColorSchemes::Select < ApplicationComponent
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo

  include PhlexConcerns::FlexBlock

  def initialize(settings:, preview_color_scheme:, color_scheme_options: [])
    @settings = settings
    @preview_color_scheme = preview_color_scheme
  end

  def view_template
    flex_block do
      span(class: "text-small") { "Preview:" }

      form_with(model: @settings, url: url_for, method: :get) do |f|
        fieldset do
          f.select(
            :color_scheme_id,
            cached_curated_color_scheme_options,
            {
              prompt: "Pick one!",
              selected: previewing? && @settings.color_scheme.id
            },
            onchange: "this.form.requestSubmit()",
            class: "",
            data: send_analytics
          )
          noscript { f.submit "Preview", class: "button primary" }
        end
      end

      span(class: "text-small") { "OR" }

      link_to "I feel lucky!",
        url_for(settings: {color_scheme_id: random_curated_color_scheme_id}),
        class: "button secondary",
        data: send_analytics
    end
  end

  private

  def previewing? = @preview_color_scheme.present?

  def cached_curated_color_scheme_options
    @cached_curated_color_scheme_options ||= ColorScheme.cached_curated_color_scheme_options
  end

  def random_curated_color_scheme_id
    _display_name, id = cached_curated_color_scheme_options.sample
    id
  end

  def send_analytics
    {action: "analytics#send"}
  end
end
