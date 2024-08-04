# frozen_string_literal: true

class Settings::ColorSchemes::Form < ApplicationView
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
    @preview_color_scheme = preview_color_scheme
    @session_color_scheme = session_color_scheme
    @default_color_scheme = default_color_scheme
  end

  def view_template
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

        render Settings::ColorSchemes::Select.new(settings: @settings, preview_color_scheme: @preview_color_scheme, color_scheme_options: cached_curated_color_scheme_options)

        span(class: "text-small") { "OR" }

        link_to "I feel lucky!",
          url_for(settings: {color_scheme_id: random_curated_color_scheme_id}),
          class: "button secondary "
      end

      if previewing?
        markdown do
          "#{preview_remarks.sample} **#{@preview_color_scheme.display_name}**."
        end

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

        markdown do
          <<~MARKDOWN
            You have saved **#{@session_color_scheme.display_name}** as your personal color scheme.
          MARKDOWN
        end

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
    @cached_curated_color_scheme_options ||= ColorScheme.cached_curated_color_scheme_options
  end

  def random_curated_color_scheme_id
    _display_name, id = cached_curated_color_scheme_options.sample
    id
  end
end
