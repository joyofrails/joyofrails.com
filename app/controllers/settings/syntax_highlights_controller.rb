class Settings::SyntaxHighlightsController < ApplicationController
  def show
    @syntax_highlight = find_syntax_highlight

    render Settings::SyntaxHighlights::ShowView.new(
      settings: Settings.new(syntax_highlight: @syntax_highlight),
      available_highlights: Settings::SyntaxHighlight.curated,
      preview_syntax_highlight: preview_syntax_highlight,
      session_syntax_highlight: session_syntax_highlight,
      default_syntax_highlight: default_syntax_highlight
    )
  end

  def update
    # highlight = params[:syntax_highlight]
    # if available_highlight_styles.include?(highlight)
    #   current_user.update(syntax_highlight: highlight)
    #   flash[:notice] = "Syntax highlight updated to #{highlight}"
    # else
    #   flash[:alert] = "Invalid syntax highlight choice"
    # end
    # redirect_to action: :show

    syntax_highlight = params.fetch(:settings, {}).permit(:syntax_highlight)
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
