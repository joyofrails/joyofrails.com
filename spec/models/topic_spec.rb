require "rails_helper"

RSpec.describe Topic, type: :model do
  describe ".create_from_list" do
    it "creates topics from list" do
      topics = ["Rails", "Ruby", "Ruby on Rails"]
      statuses = ["pending", "approved", "rejected"]

      statuses.each do |status|
        created_topics = Topic.create_from_list(topics, status: status)
        expect(created_topics.pluck(:status).uniq).to eq [status]
        Topic.where(name: topics).destroy_all
      end
    end

    it "shouldn't update status of exiting topic" do
      topic = FactoryBot.create(:topic, :approved, name: "Ruby on Rails")
      assert_equal "approved", topic.status

      created_topics = Topic.create_from_list([topic.name], status: "pending")

      expect(created_topics.length).to eq 1
      expect(created_topics.first.status).to eq "approved"
    end

    it "handles duplicated topics" do
      topics = ["Rails", "Rails", "Ruby", "Rails on Rails"]

      expect {
        Topic.create_from_list(topics)
      }.to change(Topic, :count).by(3)
    end
  end

  describe "#rejected!" do
    it "reject invalid topics" do
      topic = FactoryBot.create(:topic, :approved)

      page = Page.find_or_create_by!(request_path: "/articles/custom-color-schemes-with-ruby-on-rails")

      page.topics = [topic]

      expect(topic.pages.count).to be > 0

      topic.rejected!

      expect(topic.pages.count).to be 0
    end
  end
end
