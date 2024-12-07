require "rails_helper"

RSpec.describe "rails deploy", type: :task do
  describe ":finish" do
    it "doesn’t blow up" do
      FactoryBot.create(:user, :primary_author)

      expect {
        Rake::Task["deploy:finish"].invoke
      }.not_to raise_error
    end
  end
end
