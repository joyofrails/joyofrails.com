# frozen_string_literal: true

class Settings::ColorSchemes::Select < ApplicationComponent
  include Phlex::Rails::Helpers::FormWith

  def initialize(settings:, preview_color_scheme:, color_scheme_options: [])
    @settings = settings
    @preview_color_scheme = preview_color_scheme
    @color_scheme_options = color_scheme_options
  end

  def view_template
    form_with(model: @settings, url: url_for, method: :get) do |f|
      fieldset do
        f.select(
          :color_scheme_id,
          @color_scheme_options,
          {
            prompt: "Pick one!",
            selected: previewing? && @settings.color_scheme.id
          },
          onchange: "this.form.requestSubmit()",
          class: ""
        )
        noscript { f.submit "Preview", class: "button primary" }
      end
    end
  end

  private

  def previewing? = @preview_color_scheme.present?

  def cached_curated_color_scheme_options
    Rails.cache.fetch("curated_color_scheme_options", expires_in: 1.day) do
      ColorScheme.curated.sort_by { |cs| cs.name }.map { |cs| [cs.display_name, cs.id] }
    end
  end
end
