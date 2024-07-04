# frozen_string_literal: true

class ColorSchemes::Form < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ContentFor

  def initialize(
    settings:,
    curated_color_schemes: [],
    default_color_scheme: ColorScheme.cached_default,
    preview_color_scheme: nil,
    session_color_scheme: nil
  )
    @settings = settings
    @color_scheme = settings.color_scheme
    @curated_color_schemes = curated_color_schemes
    @preview_color_scheme = preview_color_scheme
    @session_color_scheme = session_color_scheme
    @default_color_scheme = default_color_scheme
  end

  def view_template
    style do
      render(ColorSchemes::Css.new(color_scheme: @color_scheme))
    end

    div(class: "grid grid-row-mid") do
      if previewing? || preserving?
        h3 do
          plain "You are now #{(@color_scheme == @session_color_scheme) ? "using" : "previewing"} the"
          whitespace
          span(class: "emphasis") { @color_scheme.display_name }
          whitespace
          plain "color scheme"
        end
      else
        h3 { "Want to try something different?" }
      end

      p do
        plain "This site uses a monochromatic color scheme."
        whitespace
        plain "You can preview and save a new color scheme right here."
        whitespace
        plain "I have curated some options for you."
        whitespace
        plain "Get a random one if you’re feeling lucky."
      end

      div(class: "flex items-center") do
        preview_select

        span(class: "mr-2 text-small") { "OR" }

        link_to "I feel lucky!",
          url_for(settings: {color_scheme_id: @curated_color_schemes.sample.id}),
          class: "button secondary mr-2"

        if previewing? && (@color_scheme != (@session_color_scheme || @default_color_scheme))
          span(class: "mr-2 text-small") { "OR" }

          link_to "Reset preview",
            url_for,
            class: "button tertiary mr-2"
        end
      end

      if previewing?
        p do
          plain "Here is the color scheme for"
          whitespace
          strong { @preview_color_scheme.display_name }
        end
        color_swatches(@preview_color_scheme)
        p do
          plain "Click"
          whitespace
          span(class: "emphasis") { "Save" }
          whitespace
          plain "to browse the site with"
          whitespace
          strong { @preview_color_scheme.display_name }
          whitespace
          plain "as your new color scheme."
        end
        save_preview_button
      end

      if preserving?
        p do
          plain "You have saved"
          whitespace
          strong { @session_color_scheme.display_name }
          whitespace
          plain "as your personal color scheme."
        end
        color_swatches(@session_color_scheme)
        p do
          plain "You can delete"
          whitespace
          strong { @session_color_scheme.display_name }
          whitespace
          plain "as your color scheme choice and go back to the default color scheme."
        end
        unsave_button
      end

      p do
        plain "For reference,"
        whitespace
        strong { @default_color_scheme.display_name }
        whitespace
        plain "is the default color scheme for the site."
      end
      color_swatches(@default_color_scheme)
    end
  end

  def preview_select
    form_with(model: @settings, url: url_for, method: :get) do |f|
      fieldset do
        f.select(
          :color_scheme_id,
          @curated_color_schemes.sort_by { |cs| cs.name }.map { |cs| [cs.display_name, cs.id] },
          {
            prompt: "Pick one!",
            selected: previewing? && @color_scheme.id
          },
          # requestSubmit and Turbo
          # https://stackoverflow.com/questions/68624668/how-can-i-submit-a-form-on-input-change-with-turbo-streams
          onchange: "this.form.requestSubmit()",
          class: "mr-2"
        )
      end
    end
  end

  def save_preview_button
    button_to "Save #{@preview_color_scheme.display_name}",
      settings_color_scheme_path(settings: {color_scheme_id: @preview_color_scheme.id}),
      method: :patch,
      class: "button primary mr-2"
  end

  def unsave_button
    button_to "Delete my color scheme choice",
      settings_color_scheme_path(settings: {color_scheme_id: ColorScheme.cached_default.id}),
      method: :patch,
      class: "button warn mr-2",
      form: {class: "text-right"}
  end

  def color_swatches(color_scheme)
    div(class: "color-scheme color-scheme__#{color_scheme.name.parameterize}") do
      color_scheme.weights.each do |weight, color|
        div(class: "color-swatch color-swatch__weight:#{weight}", style: "background-color: #{color.hex}") do
          div(class: "color-swatch__weight") { weight }
          div(class: "color-swatch__color") { color.hex.delete("#").upcase }
        end
      end
    end
  end

  private

  def previewing? = @preview_color_scheme.present?

  def preserving? = @session_color_scheme.present?

  def default_color_scheme? = @color_scheme.id == @default_color_scheme
end
