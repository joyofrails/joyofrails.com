class Errors::SpotifyEmbed < ApplicationComponent
  def initialize(src:, **iframe_options)
    @src = src
    @iframe_options = iframe_options
  end

  def view_template
    iframe(
      src: @src,
      width: "100%",
      height: "352",
      frameborder: "0",
      allowfullscreen: "",
      allow: "autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture",
      loading: "lazy",
      style: "border-radius:12px",
      **@iframe_options
    )
  end
end
