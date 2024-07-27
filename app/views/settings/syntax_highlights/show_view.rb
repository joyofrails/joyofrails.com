class Settings::SyntaxHighlights::ShowView < ApplicationView
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(current_highlight:, available_highlights:)
    @current_highlight = current_highlight
    @available_highlights = available_highlights
  end

  def view_template
    render Pages::Header.new(title: "Settings: Syntax Highlight")

    section(class: %(secton-content container py-gap)) do
      turbo_frame_tag "syntax-highlight-form", data: {turbo_action: "advance"} do
        render Settings::SyntaxHighlights::Form.new(
          current_highlight: @current_highlight,
          available_highlights: @available_highlights
        )
      end
    end
  end
end
