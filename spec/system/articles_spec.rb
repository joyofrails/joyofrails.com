require "rails_helper"

RSpec.describe "Articles", type: :system do
  it "displays articles" do
    visit "/articles"

    expect(page).to have_content("Articles")
  end

  it "displays a single article" do
    article = FactoryBot.create(:page, :published, request_path: "/articles/custom-color-schemes-with-ruby-on-rails")

    visit "/articles"

    click_on article.title

    within("header.page-header") do
      expect(page).to have_content(article.title)
    end
  end

  it "displays article topics" do
    article = FactoryBot.create(:page, :published, request_path: "/articles/custom-color-schemes-with-ruby-on-rails")

    article.topics << FactoryBot.create_list(:topic, 2, :approved)
    article.topics << FactoryBot.create_list(:topic, 1, :pending)
    article.topics << FactoryBot.create_list(:topic, 1, :rejected)
    article.save!

    visit article.request_path

    within("header.page-header") do
      expect(page).to have_content(article.title)
    end

    expect(article.topics.count).to eq(4)
    expect(article.topics.approved.count).to eq(2)

    article.topics.approved.each do |topic|
      expect(page).to have_link("##{topic.slug}", href: topic_path(topic))
    end
    (article.topics.rejected + article.topics.pending).each do |topic|
      expect(page).not_to have_link("##{topic.slug}", href: topic_path(topic))
    end

    first_topic = article.topics.first
    click_link "##{first_topic.slug}"

    within("header.page-header") do
      expect(page).to have_content("Topics")
    end
    expect(page).to have_content(first_topic.name)
    expect(page).to have_content(article.title)
  end

  it "displays similar articles" do
    article = FactoryBot.create(:page, :published, request_path: "/articles/web-push-notifications-from-rails")
    similar = FactoryBot.create(:page, :published, request_path: "/articles/add-your-rails-app-to-the-home-screen")

    embeddings_yaml = YAML.load_file(Rails.root.join("spec/fixtures/embeddings.yml"))

    [article, similar].each do |page|
      PageEmbedding.upsert_embedding!(page, embeddings_yaml[page.request_path])
    end

    visit article.request_path

    expect(page).to have_content("More articles to enjoy")
    expect(page).to have_link(similar.title, href: similar.request_path)
  end
end
