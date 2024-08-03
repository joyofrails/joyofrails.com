module SyntaxHighlighting
  extend ActiveSupport::Concern

  included do
    helper_method :find_syntax_highlight
    helper_method :custom_syntax_highlight?
  end

  def find_syntax_highlight
    @syntax_highlight ||= preview_syntax_highlight || session_syntax_highlight || default_syntax_highlight
  end

  def custom_syntax_highlight? = preview_syntax_highlight_name.present? || session_syntax_highlight_name.present?

  def preview_syntax_highlight_name = params.fetch(:settings, {}).permit(:syntax_highlight_name)[:syntax_highlight_name]

  def session_syntax_highlight_name = session[:syntax_highlight]

  def preview_syntax_highlight = @preview_syntax_highlight ||= preview_syntax_highlight_name && Settings::SyntaxHighlight.find(preview_syntax_highlight_name)

  def session_syntax_highlight = @session_syntax_highlight ||= session_syntax_highlight_name && Settings::SyntaxHighlight.find(session_syntax_highlight_name)

  def default_syntax_highlight = @default_syntax_highlight ||= Settings::SyntaxHighlight.default
end
