require "rails_helper"
require_relative "../../lib/generators/article/article_generator"

RSpec.describe ArticleGenerator, type: :generator do
  before do
    FileUtils.rm_rf("app/assets/images/articles/my-new-article")
  end
  after do
    FileUtils.rm_rf("app/assets/images/articles/my-new-article")
  end

  it "creates a new article" do
    run_generator ["My New Article"]

    aggregate_failures do
      expect("app/assets/images/articles/my-new-article/placeholder.jpg").to be_file

      expect("app/content/pages/articles/my-new-article.html.mdrb").to be_file do |content|
        expect(content).to eq(<<~FILE)
          ---
          title: My New Article
          author: Ross Kaffenberger
          layout: article
          summary: Here is the summary
          description: Here is the description that will show up in the the meta tag
          published: "#{Date.today + 7}"
          image: articles/my-new-article/placeholder.jpg
          meta_image: articles/my-new-article/placeholder.jpg
          tags:
            - Rails
          ---

          Hello World
        FILE
      end

      expect("spec/system/content/my-new-article_spec.rb").to be_file
    end
  end
end
