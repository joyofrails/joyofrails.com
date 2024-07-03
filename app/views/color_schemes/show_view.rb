# frozen_string_literal: true

class ColorSchemes::ShowView < ApplicationView
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
    content_for :head do
      render("application/theme/color")
    end
    render Pages::Header.new(title: "Theme: Color")
    div(class: "section-content container py-gap") do
      if previewing? || preserving?
        h3 do
          plain "You are now #{(@color_scheme == @session_color_scheme) ? "using" : "previewing"} the"
          whitespace
          span(class: "emphasis") { @color_scheme.display_name }
          whitespace
          plain "color scheme"
        end
      else
        h3 { "Want to try a different color scheme?" }
      end

      p { "You can preview and save your desired color scheme for this site. We have curated some options for you below." }

      div(class: "flex items-center") do
        preview_select

        span(class: "mr-2 text-small") { "OR" }

        link_to "I feel lucky!",
          settings_color_scheme_path(settings: {color_scheme_id: @curated_color_schemes.sample.id}),
          class: "button secondary mr-2"

        if previewing? && (@color_scheme != (@session_color_scheme || @default_color_scheme))
          span(class: "mr-2 text-small") { "OR" }

          link_to "Reset preview",
            settings_color_scheme_path,
            class: "button tertiary mr-2"
        end
      end

      if previewing?
        h3 { @preview_color_scheme.display_name }
        p { "You are previewing #{@preview_color_scheme.display_name}." }
        color_swatches(@preview_color_scheme)
        p do
          plain "Click"
          whitespace
          span(class: "emphasis") { "Save" }
          whitespace
          plain "to set #{@preview_color_scheme.display_name} as your new color scheme."
        end
        save_preview_button
      end

      if preserving?
        h3 { @session_color_scheme.display_name }
        p { "You have saved #{@session_color_scheme.display_name} as your personal color scheme." }
        color_swatches(@session_color_scheme)
      end

      h3 { @default_color_scheme.display_name }
      p { "This is the default color scheme for this site." }
      color_swatches(@default_color_scheme)
      if preserving?
        p { "You can delete #{@session_color_scheme.display_name} as your color scheme choice and go back to the default color scheme by clicking the Delete button below." }
        unsave_button
      end
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
      class: "button warn mr-2"
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
