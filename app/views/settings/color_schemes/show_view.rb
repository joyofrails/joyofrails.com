# frozen_string_literal: true

class Settings::ColorSchemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag

  include Settings::ColorSchemes::PreviewRemarks

  def initialize(
    settings:,
    curated_color_schemes: [],
    default_color_scheme: ColorScheme.cached_default,
    preview_color_scheme: nil,
    session_color_scheme: nil
  )
    @settings = settings
    @color_scheme = settings.color_scheme
    @preview_color_scheme = preview_color_scheme
    @session_color_scheme = session_color_scheme
    @default_color_scheme = default_color_scheme
  end

  def view_template
    render Pages::Header.new(title: "Settings: Color Scheme")

    section(class: "section-content container py-gap") do
      turbo_frame_tag "color-scheme-form", data: {turbo_action: "advance"} do
        style do
          render(ColorSchemes::Css.new(color_scheme: @session_color_scheme)) if @session_color_scheme
          render(ColorSchemes::Css.new(color_scheme: @color_scheme, my_theme_enabled: true))
        end

        div(class: "grid grid-content") do
          if previewing?
            h2 do
              plain "You are now previewing"
              whitespace
              span(class: "emphasis") { @color_scheme.display_name }
            end
          else
            h2 { "Want to preview a new color?" }
          end

          markdown do
            <<~MARKDOWN
              The color scheme for this site is monochromatic. You can use the select menu to preview a new color scheme with a different base color. I have curated over a hundred options for you from [uicolors.app](https://uicolors.app). Get a random one if you’re feeling lucky.
            MARKDOWN
          end

          render Settings::ColorSchemes::Select.new(settings: @settings, preview_color_scheme: @preview_color_scheme)

          if previewing?
            markdown { "#{preview_remarks.sample} **#{@preview_color_scheme.display_name}**." }
            render ColorSchemes::Swatches.new(color_scheme: @preview_color_scheme)

            darkmode_section

            markdown do
              <<~MARKDOWN
                Click the Save button to keep this choice and browse the site with **#{@preview_color_scheme.display_name}** Saving adds the color scheme as a session cookie that will persist across page views on your current device. You can delete the color scheme choice at any time.
              MARKDOWN
            end

            div(class: "outside") do
              save_preview_button
            end

            markdown do
              "Click the **Reset preview** button to go back to #{@session_color_scheme ? "your saved color scheme" : "the default color scheme"}."
            end
            div(class: "outside") { reset_button }
          end

          if preserving?
            h2 {
              plain "Your saved color scheme:"
              whitespace
              span(style: inline_style_header_color(@session_color_scheme)) { @session_color_scheme.display_name }
            }

            markdown { "You have saved **#{@session_color_scheme.display_name}** as your personal color scheme." }

            render ColorSchemes::Swatches.new(color_scheme: @session_color_scheme)

            if !previewing?
              darkmode_section
            end

            p do
              "You can delete your saved color scheme and go back to the default."
            end
            div(class: "outside") { unsave_button }
          end

          h2 {
            plain "Site default:"
            whitespace
            span(style: inline_style_header_color(@default_color_scheme)) { @default_color_scheme.display_name }
          }
          markdown do
            "For reference, **#{@default_color_scheme.display_name}** is the default color scheme for the site."
          end

          render ColorSchemes::Swatches.new(color_scheme: @default_color_scheme)

          if !preserving? && !previewing?
            darkmode_section
          end

          markdown do
            "There’s nothing wrong with keeping the defaults—it’s a classic choice."
          end
        end
      end
    end
  end

  def save_preview_button
    button_to "Save #{@preview_color_scheme.display_name}",
      settings_color_scheme_path(settings: {color_scheme_id: @preview_color_scheme.id}),
      method: :patch,
      class: "button primary"
  end

  def unsave_button
    button_to "Delete my color scheme choice",
      settings_color_scheme_path(settings: {color_scheme_id: ColorScheme.cached_default.id}),
      method: :patch,
      class: "button warn",
      style: "min-width: 25ch;"
  end

  def reset_button
    link_to "Reset preview",
      url_for,
      class: "button tertiary"
  end

  def darkmode_section
    noscript do
      markdown do
        "*Disclaimer: The Light/Dark mode switch is not available without JavaScript enabled.*"
      end
    end

    markdown do
      "You can toggle the dark mode switch to see how the color scheme looks in light or dark mode. Choosing **Light Mode** or **Dark Mode** will save in your browser local storage and will persist across page views on your current device. Choose **System Mode** to remove the saved choice and fall back to your system preference."
    end
    div(class: "outside") do
      render "darkmode/switch", enable_description: true, enable_outline: true
    end
  end

  private

  def previewing? = @preview_color_scheme.present?

  def preserving? = @session_color_scheme.present?

  def default_color_scheme? = @color_scheme.id == @default_color_scheme

  def inline_style_header_color(color_scheme)
    "color: var(--color-#{color_scheme.name.parameterize}-500)"
  end
end
