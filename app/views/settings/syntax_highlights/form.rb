class Settings::SyntaxHighlights::Form < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::TurboStream

  def initialize(
    settings:,
    available_highlights: [],
    default_syntax_highlight: Settings::SyntaxHighlight.default,
    preview_syntax_highlight: nil,
    session_syntax_highlight: nil
  )
    @settings = settings
    @current_highlight = settings.syntax_highlight
    @available_highlights = available_highlights
    @preview_syntax_highlight = preview_syntax_highlight
    @session_syntax_highlight = session_syntax_highlight
    @default_syntax_highlight = default_syntax_highlight
  end

  def view_template
    div(
      class: "grid grid-content"
    ) do
      h2 { "Want to preview a new syntax highlighting theme?" }

      markdown do
        "This site uses [Pygments-style CSS](https://pygments.org/) for syntax highlighting. You can use the select menu to preview a new syntax highlighting theme. I have curated over 90 options for you from sources around the web."
      end

      preview_select

      h2 { %(Preview) }

      markdown do
        "You can preview what the site looks with this syntax highlighting theme while you remain on this page."
      end

      flex_list do
        div do
          h3 { %(Ruby) }
          render CodeBlock::AppFile.new("app/models/examples/counter.rb", language: "rb")
        end
        div do
          h3 { %(CSS) }
          render CodeBlock::AppFile.new("app/javascript/css/components/site-header.css", language: "css")
        end
        div do
          h3 { %(JavaScript) }
          render CodeBlock::AppFile.new("app/javascript/controllers/application.js", language: "js")
        end
        div do
          h3 { %(HTML with ERB) }
          render CodeBlock::AppFile.new("app/views/examples/counters/show.html.erb", language: "erb")
        end
      end
    end

    div(id: "syntax-highlight-preview-results", class: "grid grid-content") do
      preview_result
    end
  end

  def darkmode_section
    noscript do
      markdown do
        "*Disclaimer: The Light/Dark mode switch is not available without JavaScript enabled.*"
      end
    end

    markdown do
      "Toggle this switch to see the syntax highlighting when the _site_ is Light or Dark Mode. Choosing **Light Mode** or **Dark Mode** will save in your browser local storage and will persist across page views on your current device. Choose **System Mode** to remove the saved choice and fall back to your system preference."
    end
    div(class: "outside") do
      render "darkmode/switch", enable_description: true, enable_outline: true
    end
  end

  def preview_select
    turbo_frame_tag "syntax-highlight-preview" do
      stylesheet_link_tag @current_highlight.asset_path, data: {syntax_highlight: @current_highlight.name}

      form_with(
        model: @settings,
        url: settings_syntax_highlight_path,
        method: :get,
        data: {
          controller: "syntax-highlight-preview",
          syntax_highlight_preview_name_value: @current_highlight.name,
          turbo_action: "advance"
        }
      ) do |form|
        fieldset do
          flex_block do
            form.label :syntax_highlight_name, "Choose another syntax highlighting theme to preview:"
            form.select :syntax_highlight_name,
              syntax_highlight_options_for_select,
              {
                selected: @current_highlight.name,
                autocomplete: "off"
              },
              data: {
                syntax_highlight_preview_target: "select",
                action: "change->syntax-highlight-preview#change"
              }
          end
        end
      end

      turbo_stream.update "syntax-highlight-preview-results" do
        preview_result
      end
    end
  end

  def preview_result
    if default?
      h2 { "Your syntax highlighting theme" }

      markdown do
        "You are currently using the default syntax highlighting theme, **#{@default_syntax_highlight.display_name}** as your syntax highlighting theme."
      end

      darkmode_section

      return
    end

    if previewing?
      h2 { "Save your preview" }

      markdown do
        "You are currently previewing **#{@current_highlight.display_name}** as your syntax highlighting theme."
      end

      darkmode_section

      markdown do
        "Click the Save button to preserve **#{@current_highlight.display_name}** as your new syntax highlighting theme. Your choice will be saved in your browser session."
      end

      div(class: "outside") do
        button_to("Save #{@current_highlight.display_name}",
          settings_syntax_highlight_path(settings: {syntax_highlight_name: @current_highlight.name}),
          method: :patch,
          class: "button primary")
      end

      markdown do
        "Click the **Reset preview** button to go back to #{@session_syntax_highlight ? "your saved color scheme, **#{@session_syntax_highlight.display_name}**" : "the default color scheme, **#{@default_syntax_highlight.display_name}**"}."
      end

      div(class: "outside") { reset_button }
    end

    if preserving?
      h2 { "Your syntax highlighting theme" }

      markdown do
        "You have saved **#{@session_syntax_highlight.display_name}** for syntax highlighting across the site."
      end

      darkmode_section if !previewing?

      markdown do
        "You can delete #{@session_syntax_highlight.display_name} your saved syntax highlighting theme and go back to the default."
      end
      div(class: "outside") { unsave_button }
    end
  end

  def flex_block(options = {}, &)
    div(class: "flex items-start flex-col space-col-4 grid-cols-12 md:items-center md:flex-row md:space-row-4 #{options[:class]}", &)
  end

  def flex_list(options = {}, &)
    div(class: "code-examples--list flex items-start flex-col space-col-4 grid-cols-12 md:flex-row md:space-row-4 #{options[:class]}", &)
  end

  def syntax_highlight_options_for_select
    @available_highlights
      .group_by { |sh| sh.mode }
      .map { |mode, syntaxes| [mode.titleize, syntaxes.map { |sh| [sh.name.titleize, sh.name] }] }
  end

  def reset_button
    link_to "Reset preview",
      url_for,
      class: "button tertiary"
  end

  def unsave_button
    button_to "Delete my syntax highlighting choice",
      settings_syntax_highlight_path(settings: {syntax_highlight_name: @default_syntax_highlight.name}),
      method: :patch,
      class: "button warn",
      style: "min-width: 25ch;"
  end

  private

  def previewing? = @preview_syntax_highlight.present?

  def preserving? = @session_syntax_highlight.present?

  def default? = @current_highlight == @default_syntax_highlight

  def markdown
    render Markdown::Application.new(yield)
  end
end
