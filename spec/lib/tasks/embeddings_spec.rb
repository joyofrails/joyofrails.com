require "rails_helper"

RSpec.describe "rails deploy", type: :task do
  describe ":finish" do
    it "doesn’t blow up" do
      FactoryBot.create(:page, :published)

      expect {
        Rake::Task["embeddings:upsert_random"].invoke
      }.not_to raise_error
    end
  end
end
