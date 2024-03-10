require "rails_helper"
require_relative "../../lib/generators/article/article_generator"

RSpec.describe ArticleGenerator, type: :generator do
  tests ArticleGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  it "creates a new article" do
    run_generator ["My New Article"]

    assert_file("app/content/pages/articles/my-new-article.html.md", <<~FILE)
      ---
      title: My New Article
      author: Ross Kaffenberger
      layout: article
      summary: Here is the summary
      description: Here is the description that will show up in the the meta day
      published: "#{7.days.from_now.to_date}"
      draft: true
      tags:
        - Rails
      ---

      Hello World
    FILE
  end
end
