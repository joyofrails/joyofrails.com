namespace :fixtures do
  task html: :environment do
    require_relative "../../html_fixtures/renderer"

    HtmlFixtures::Renderer.new.render_all
  end
end
