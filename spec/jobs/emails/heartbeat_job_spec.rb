require "rails_helper"

RSpec.describe Emails::HeartbeatJob do
  describe "#perform" do
    it "sends a heartbeat email to admin users to exercise email provider integration" do
      admin_user = FactoryBot.create(:admin_user)

      Emails::HeartbeatJob.perform_later

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(admin_user.email)

      expect(mail.subject).to eq("It’s alive!")
    end
  end
end
