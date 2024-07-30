class Settings::SyntaxHighlights::Form < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::StylesheetLinkTag

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
    stylesheet_link_tag @current_highlight.asset_path, data: {syntax_highlight: @current_highlight.name}

    div(
      class: "grid grid-content",
      data: {
        controller: "syntax-highlight-preview",
        syntax_highlight_preview_name_value: @current_highlight.name
      }
    ) do
      h2 { "Want to preview a new syntax highlighting theme?" }

      markdown do
        "This site uses [Pygments-style CSS](https://pygments.org/) for syntax highlighting. You can use the select menu to preview a new syntax highlighting theme. I have curated over 90 options for you from sources around the web."
      end

      if previewing?
        markdown do
          "You are currently previewing **#{@current_highlight.display_name}** as your syntax highlighting theme."
        end
      end

      if preserving?
        markdown do
          "You have saved **#{@session_syntax_highlight.display_name}** for syntax highlighting across the site."
        end
      end
      preview_select

      if previewing?
        markdown do
          "You can preview what the site looks with this syntax highlighting theme while you remain on this page. Click the **Reset preview** button to go back to #{@session_syntax_highlight ? "your saved color scheme, **#{@session_syntax_highlight.display_name}**" : "the default color scheme, **#{@default_syntax_highlight.display_name}**"}."
        end

        div(class: "outside") { reset_button }

        darkmode_section

        markdown do
          "Click the Save button to preserve **#{@current_highlight.display_name}** as your new syntax highlighting theme."
        end

        div(class: "outside") do
          button_to("Save #{@current_highlight.display_name}",
            settings_syntax_highlight_path(settings: {syntax_highlight_name: @current_highlight.name}),
            method: :patch,
            class: "button primary")
        end
      end

      h2 { %(Preview) }

      h3 { %(Ruby) }

      render CodeBlock::Article.new(language: "ruby") do |code|
        code.body do
          <<~RUBY.html_safe
            class Family < Group
              include Enumerable

              def initialize(*members)
                @members = members
              end

              def each(&)
                @members.each(&)
              end
            end
          RUBY
        end
      end
      h3 { %(CSS) }
      render CodeBlock::Article.new(language: "css") do |code|
        code.body do
          <<~CSS
            body {
              font-size: 12pt;
              background: #fff url(temp.png) top left no-repeat;
            }
          CSS
        end
      end
      h3 { %(JavaScript) }
      render CodeBlock::AppFile.new("app/javascript/controllers/syntax-highlight/preview.js", language: "js")
      h3 { %(HTML with ERB) }
      render CodeBlock::AppFile.new("app/views/layouts/application.html.erb", language: "erb")
    end
  end

  def darkmode_section
    noscript do
      markdown do
        "*Disclaimer: The Light/Dark mode switch is not available without JavaScript enabled.*"
      end
    end

    markdown do
      "You can toggle the dark mode switch to see how the syntax highlighting looks in light or dark mode. Choosing **Light Mode** or **Dark Mode** will save in your browser local storage and will persist across page views on your current device. Choose **System Mode** to remove the saved choice and fall back to your system preference."
    end
    div(class: "outside") do
      render "darkmode/switch", enable_description: true, enable_outline: true
    end
  end

  private

  def previewing? = @preview_syntax_highlight.present?

  def preserving? = @session_syntax_highlight.present?

  def markdown
    render Markdown::Application.new(yield)
  end

  def m
    Markdown::Application.new(yield).call.html_safe
  end

  def preview_select
    form_with(
      model: @settings,
      url: settings_syntax_highlight_path,
      method: :get
    ) do |form|
      fieldset do
        flex_block do
          form.label :syntax_highlight_name, "Choose another syntax highlighting theme to preview:"
          form.select :syntax_highlight_name,
            syntax_highlight_options_for_select,
            {
              selected: @current_highlight.name
            },
            onchange: "this.form.requestSubmit()"
        end
      end
    end
  end

  def flex_block(options = {}, &)
    div(class: "flex items-start flex-col space-col-4 grid-cols-12 md:items-center md:flex-row md:space-row-4 #{options[:class]}", &)
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
end
