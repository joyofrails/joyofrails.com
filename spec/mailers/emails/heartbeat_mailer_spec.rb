require "rails_helper"

RSpec.describe Emails::HeartbeatMailer, type: :mailer do
  it "heartbeat" do
    # Create the email and store it for further assertions
    email = Emails::HeartbeatMailer.with(to: "friend@example.com").heartbeat

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    expect(email.from).to eq ["hello@joyofrails.com"]
    expect(email.to).to eq ["friend@example.com"]
    expect(email.subject).to eq "It’s alive!"
    expect(email.body.encoded).to match("The Joy of Rails email integration is working!")
  end
end
