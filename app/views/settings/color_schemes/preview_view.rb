# frozen_string_literal: true

class Settings::ColorSchemes::PreviewView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
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
    render Pages::Header.new(title: "Settings: Color Scheme Preview")

    section(class: "section-content container py-gap") do
      turbo_frame_tag "color-scheme-preview", data: {turbo_action: "advance"} do
        style do
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

          render Settings::ColorSchemes::Select.new(
            settings: @settings,
            preview_color_scheme: @preview_color_scheme
          )

          if previewing?
            markdown { "#{preview_remarks.sample} **#{@color_scheme.display_name}**." }
            render ColorSchemes::Swatches.new(color_scheme: @settings.color_scheme)

            markdown do
              "Click the **Reset preview** button to go back to #{@session_color_scheme ? "your saved color scheme" : "the default color scheme"}."
            end
            div(class: "outside") { reset_button }
          else
            if preserving?
              markdown do
                "You have saved **#{@color_scheme.display_name}** as your personal color scheme."
              end
            else
              markdown do
                "The site default color scheme is **#{@color_scheme.display_name}**."
              end
            end

            render ColorSchemes::Swatches.new(color_scheme: @settings.color_scheme)
          end
        end
      end
    end
  end

  def reset_button
    link_to "Reset preview",
      url_for,
      class: "button tertiary"
  end

  private

  def previewing? = @preview_color_scheme.present?

  def preserving? = @session_color_scheme.present?

  def default_color_scheme? = @color_scheme.id == @default_color_scheme

  def inline_style_header_color(color_scheme)
    "color: var(--color-#{color_scheme.name.parameterize}-500)"
  end
end
