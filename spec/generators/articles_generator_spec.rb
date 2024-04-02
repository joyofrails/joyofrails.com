require "rails_helper"
require_relative "../../lib/generators/article/article_generator"

RSpec.describe ArticleGenerator, type: :generator do
  it "creates a new article" do
    run_generator ["My New Article"]

    expect("app/content/pages/articles/my-new-article.html.md").to be_file do |content|
      expect(content).to eq(<<~FILE)
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
end
