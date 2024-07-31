class Settings::SyntaxHighlightsController < ApplicationController
  def show
    @syntax_highlight = find_syntax_highlight

    respond_to do |format|
      format.html {
        render Settings::SyntaxHighlights::ShowView.new(
          settings: Settings.new(syntax_highlight: @syntax_highlight),
          available_highlights: Settings::SyntaxHighlight.curated,
          preview_syntax_highlight: preview_syntax_highlight,
          session_syntax_highlight: session_syntax_highlight,
          default_syntax_highlight: default_syntax_highlight
        )
      }
      format.css {
        render file: @syntax_highlight.path, layout: false
      }
    end
  end

  def update
    syntax_highlight = params.fetch(:settings, {}).permit(:syntax_highlight_name)[:syntax_highlight_name]
    @syntax_highlight = Settings::SyntaxHighlight.find(syntax_highlight)

    redirect_to settings_syntax_highlight_path unless @syntax_highlight.present?

    if @syntax_highlight == Settings::SyntaxHighlight.default
      session.delete(:syntax_highlight)
    else
      session[:syntax_highlight] = @syntax_highlight.name
    end

    redirect_to settings_syntax_highlight_path, status: :see_other
  end
end
