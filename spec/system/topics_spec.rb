require "rails_helper"

RSpec.describe "Topics", type: :system do
  it "displays the topics and provides navigation links" do
    Page.upsert_from_sitepress!(limit: 3)

    expect(Page.count).to eq(3)

    Page.find_each do |model|
      model.topics = FactoryBot.create_list(:topic, 2, :approved)
      model.save!
    end

    visit topics_path

    expect(page).to have_content("Topics")

    Topic.approved.find_each do |topic|
      expect(page).to have_link(topic.name, href: topic_path(topic))
    end

    topic = Topic.first

    click_link topic.name

    expect(page).to have_content(topic.name)

    topic.pages.each do |model|
      expect(page).to have_link(model.title, href: model.request_path)
    end
  end
end
