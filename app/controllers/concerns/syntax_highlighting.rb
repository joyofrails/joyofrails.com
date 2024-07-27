module SyntaxHighlighting
  extend ActiveSupport::Concern

  included do
    helper_method :find_syntax_highlight
  end

  def find_syntax_highlight
    @syntax_highlight ||= preview_syntax_highlight || session_syntax_highlight || default_syntax_highlight
  end

  def preview_syntax_highlight_id = params.fetch(:settings, {}).permit(:syntax_highlight)[:syntax_highlight]

  def session_syntax_highlight_id = session[:syntax_highlight]

  def preview_syntax_highlight = @preview_syntax_highlight ||= preview_syntax_highlight_id && Settings::SyntaxHighlight.find(preview_syntax_highlight_id)

  def session_syntax_highlight = @session_syntax_highlight ||= session_syntax_highlight_id && Settings::SyntaxHighlight.find(session_syntax_highlight_id)

  def default_syntax_highlight = @default_syntax_highlight ||= Settings::SyntaxHighlight.default
end
