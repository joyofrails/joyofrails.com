class Settings::SyntaxHighlights::ShowView < ApplicationView
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(
    settings:,
    available_highlights:,
    preview_syntax_highlight:,
    session_syntax_highlight:,
    default_syntax_highlight:
  )
    @settings = settings
    @available_highlights = available_highlights
    @preview_syntax_highlight = preview_syntax_highlight
    @session_syntax_highlight = session_syntax_highlight
    @default_syntax_highlight = default_syntax_highlight
  end

  def view_template
    render Pages::Header.new(title: "Settings: Syntax Highlight")

    section(class: %(secton-content container py-gap)) do
      turbo_frame_tag "syntax-highlight-form", data: {turbo_action: "advance"} do
        render Settings::SyntaxHighlights::Form.new(
          settings: @settings,
          available_highlights: @available_highlights,
          preview_syntax_highlight: @preview_syntax_highlight,
          session_syntax_highlight: @session_syntax_highlight,
          default_syntax_highlight: @default_syntax_highlight
        )
      end
    end
  end
end
