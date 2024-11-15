require "rails_helper"

RSpec.describe "Articles", type: :system do
  it "displays articles" do
    visit "/articles"

    expect(page).to have_content("Articles")
  end

  it "displays a single article" do
    Page.upsert_collection_from_sitepress!(limit: 1)

    article = Page.first
    article.topics << FactoryBot.create_list(:topic, 2, :approved)
    article.topics << FactoryBot.create_list(:topic, 1, :pending)
    article.topics << FactoryBot.create_list(:topic, 1, :rejected)
    article.save!

    visit "/articles"

    click_on article.title

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
end
