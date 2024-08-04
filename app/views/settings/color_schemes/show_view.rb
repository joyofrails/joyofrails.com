# frozen_string_literal: true

class Settings::ColorSchemes::ShowView < ApplicationView
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
    render Pages::Header.new(title: "Settings: Color Scheme")

    section(class: "section-content container py-gap") do
      turbo_frame_tag "color-scheme-form", data: {turbo_action: "advance"} do
        style do
          render(ColorSchemes::Css.new(color_scheme: @session_color_scheme)) if @session_color_scheme
          render(ColorSchemes::Css.new(color_scheme: @color_scheme, my_theme_enabled: true))
        end

        render Settings::ColorSchemes::Form.new(
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
