# frozen_string_literal: true

class ColorSchemes::PreviewView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::TurboFrameTag

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
    render Pages::Header.new(title: "Theme: Color Preview")

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

          flex_block do
            span(class: "text-small") { "Preview:" }

            render ColorSchemes::Select.new(settings: @settings, preview_color_scheme: @preview_color_scheme, color_scheme_options: cached_curated_color_scheme_options)

            span(class: "text-small") { "OR" }

            link_to "I feel lucky!",
              url_for(settings: {color_scheme_id: random_curated_color_scheme_id}),
              class: "button secondary "
          end

          if previewing?
            markdown do
              "#{preview_remarks.sample} **#{@color_scheme.display_name}**."
            end
          else
            markdown do
              "The site default is **#{@color_scheme.display_name}**."
            end
          end

          render ColorSchemes::Swatches.new(color_scheme: @settings.color_scheme)

          if previewing?
            markdown do
              "Click the **Reset preview** button to go back to #{@session_color_scheme ? "your saved color scheme" : "the default color scheme"}."
            end

            div(class: "outside") { reset_button }
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

  def markdown
    render Markdown::Application.new(yield)
  end

  def flex_block(options = {}, &)
    div(class: "flex items-start flex-col space-col-4 grid-cols-12 md:items-center md:flex-row md:space-row-4 #{options[:class]}", &)
  end

  def inline_style_header_color(color_scheme)
    "color: var(--color-#{color_scheme.name.parameterize}-500)"
  end

  def preview_remarks = [
    "Nice choice!",
    "Great pick!",
    "Looking good!",
    "I like this one!",
    "This one’s a keeper!",
    "Check this one out!",
    "One of my favorites.",
    "Ooo, I like this one!",
    "Now we’re talking!",
    "You have good taste :)",
    "What do you think?",
    "Can it get any better?",
    "Divine!",
    "My my, what a surprise:"
  ]

  def cached_curated_color_scheme_options
    Rails.cache.fetch("curated_color_scheme_options", expires_in: 1.day) do
      ColorScheme.curated.sort_by { |cs| cs.name }.map { |cs| [cs.display_name, cs.id] }
    end
  end

  def random_curated_color_scheme_id
    _display_name, id = cached_curated_color_scheme_options.sample
    id
  end
end
