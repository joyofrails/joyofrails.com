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
      render(ColorSchemes::CssVariables.new(color_scheme: @session_color_scheme)) if @session_color_scheme
      render(ColorSchemes::CssVariables.new(color_scheme: @default_color_scheme))
      render(ColorSchemes::Css.new(color_scheme: @color_scheme))
    end

    div(class: "grid grid-content") do
      if previewing?
        h2 do
          plain "You are now peviewing"
          whitespace
          span(class: "emphasis") { @color_scheme.display_name }
        end
      else
        h2 { "Want to preview a new color?" }
      end

      markdown do
        <<~MARKDOWN
          This site uses a monochromatic color scheme. You can preview and save a new color scheme below. I have curated over a hundred options for you from [uicolors.app](https://uicolors.app). Get a random one if you’re feeling lucky.
        MARKDOWN
      end

      flex_block do
        span(class: "text-small") { "Preview:" }

        preview_select

        span(class: "text-small") { "OR" }

        link_to "I feel lucky!",
          url_for(settings: {color_scheme_id: @curated_color_schemes.sample.id}),
          class: "button secondary "

        if previewing? && (@color_scheme != (@session_color_scheme || @default_color_scheme))
          span(class: "text-small") { "OR" }

          link_to "Reset preview",
            url_for,
            class: "button tertiary"
        end
      end

      if previewing?
        markdown do
          "Here is the color scheme **#{@preview_color_scheme.display_name}**. You can preview what the site looks with this color scheme while you remain on this page."
        end

        color_swatches(@preview_color_scheme)

        flex_block do
          span { "You can toggle the dark mode switch to see how the color scheme looks in light vs dark mode:" }
          render "darkmode/switch", enable_description: true, enable_outline: true
        end

        flex_block do
          markdown do
            <<~MARKDOWN
              Click the Save button to browse the site with **#{@preview_color_scheme.display_name}** as your new color scheme.
            MARKDOWN
          end

          save_preview_button
        end
      end

      if preserving?
        h2 {
          plain "Your saved color scheme:"
          whitespace
          span(style: inline_style_header_color(@session_color_scheme)) { @session_color_scheme.display_name }
        }

        markdown do
          <<~MARKDOWN
            You have saved **#{@session_color_scheme.display_name}** as your personal color scheme.
          MARKDOWN
        end

        color_swatches(@session_color_scheme)

        if !previewing?
          flex_block(class: "justify-between") do
            span { "You can toggle the dark mode switch to see how the color scheme looks in light vs dark mode:" }
            render "darkmode/switch", enable_description: true, enable_outline: true
          end
        end

        flex_block(class: "justify-between") do
          markdown do
            "You can delete **#{@session_color_scheme.display_name}** as your color scheme choice and go back to the default color scheme."
          end
          unsave_button
        end
      end

      h2 {
        plain "Site default:"
        whitespace
        span(style: inline_style_header_color(@default_color_scheme)) { @default_color_scheme.display_name }
      }
      markdown do
        "For reference, **#{@default_color_scheme.display_name}** is the default color scheme for the site."
      end
      color_swatches(@default_color_scheme)

      markdown do
        "There’s nothiing wrong with leaving the default too. It’s a classic choice."
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
          class: ""
        )
      end
    end
  end

  def save_preview_button
    button_to "Save #{@preview_color_scheme.display_name}",
      settings_color_scheme_path(settings: {color_scheme_id: @preview_color_scheme.id}),
      method: :patch,
      class: "button primary "
  end

  def unsave_button
    button_to "Delete my color scheme choice",
      settings_color_scheme_path(settings: {color_scheme_id: ColorScheme.cached_default.id}),
      method: :patch,
      class: "button warn",
      style: "min-width: 25ch;"
  end

  def color_swatches(color_scheme)
    div(class: "color-scheme color-scheme__#{color_scheme.name.parameterize} grid-cols-12") do
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

  def markdown(&block)
    render Markdown::Application.new(block.call)
  end

  def flex_block(options = {}, &)
    div(class: "flex items-start flex-col space-col-4 grid-cols-12 md:items-center md:flex-row md:space-row-4 #{options[:class]}", &)
  end

  def inline_style_header_color(color_scheme)
    "color: var(--color-#{color_scheme.name.parameterize}-500)"
  end
end
