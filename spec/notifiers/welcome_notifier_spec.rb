require "rails_helper"

RSpec.describe WelcomeNotifier do
  describe ".deliver_to" do
    it "sends at most once per user" do
      allow(Emails::UserMailer).to receive(:welcome).and_return(double(deliver_later: nil))

      user = FactoryBot.create(:user, :confirmed)

      WelcomeNotifier.deliver_to(user)
      perform_enqueued_jobs
      WelcomeNotifier.deliver_to(user)
      perform_enqueued_jobs

      expect(Emails::UserMailer).to have_received(:welcome).with(user, :no_token).once
    end
  end
end
