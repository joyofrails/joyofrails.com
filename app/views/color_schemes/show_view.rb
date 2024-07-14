# frozen_string_literal: true

class ColorSchemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::TurboFrameTag

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
    render Pages::Header.new(title: "Theme: Color")

    div(class: "section-content container py-gap") do
      turbo_frame_tag "color-scheme-form", data: {turbo_action: "advance"} do
        render ColorSchemes::Form.new(
          settings: @settings,
          curated_color_schemes: @curated_color_schemes,
          default_color_scheme: @default_color_scheme,
          preview_color_scheme: @preview_color_scheme,
          session_color_scheme: @session_color_scheme
        )
      end
    end
  end
end