class Settings::SyntaxHighlights::Form < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::StylesheetLinkTag

  def initialize(settings:, available_highlights:)
    @settings = settings
    @current_highlight = settings.syntax_highlight
    @available_highlights = available_highlights
  end

  def view_template
    stylesheet_link_tag @current_highlight.asset_path, data: {syntax_highlight: @current_highlight.name}

    div(class: "grid grid-content", data: {controller: "syntax-highlight-preview", syntax_highlight_preview_name_value: @current_highlight.name}) do
      p do
        plain %(Current syntax highlight style:)
        whitespace
        strong { @current_highlight.display_name }
      end
      form_with(
        model: @settings,
        url: settings_syntax_highlight_path,
        method: :get
      ) do |form|
        fieldset do
          flex_block do
            form.label :syntax_highlight_name, "Choose a syntax highlight style to preview:"
            form.select :syntax_highlight_name,
              syntax_highlight_options_for_select,
              {
                selected: @current_highlight.name
              },
              onchange: "this.form.requestSubmit()"
          end
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

  private

  def flex_block(options = {}, &)
    div(class: "flex items-start flex-col space-col-4 grid-cols-12 md:items-center md:flex-row md:space-row-4 #{options[:class]}", &)
  end

  def syntax_highlight_options_for_select
    @available_highlights
      .group_by { |sh| sh.mode }
      .map { |mode, syntaxes| [mode.titleize, syntaxes.map { |sh| [sh.name.titleize, sh.name] }] }
  end
end
