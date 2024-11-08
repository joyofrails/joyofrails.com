namespace :fixtures do
  task html: :environment do
    require_relative "../../html_fixtures/renderer"

    HtmlFixtures::Renderer.ensure_inline_svg_id_consistency!
    HtmlFixtures::Renderer.new.render_all
  end
end
