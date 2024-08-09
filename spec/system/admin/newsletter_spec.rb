require "rails_helper"

RSpec.describe "Admin for Newsletters", type: :system do
  it "create and edit a newsletter" do
    login_as_admin

    visit admin_newsletters_path

    click_on "New newsletter"

    fill_in "Title", with: "Welcome to Joy of Rails!"

    fill_in "Content", with: <<~MARKDOWN
      # Welcome to the newsletter

      This is the first newsletter.
    MARKDOWN

    click_button "Create Newsletter"

    expect(page).to have_content("Newsletter was successfully created.")

    expect(page).to have_content("Welcome to Joy of Rails!")

    click_link "Back to newsletters"

    expect(page).to have_content("Welcome to Joy of Rails!")

    within "#newsletters" do
      click_link "Edit"
    end

    fill_in "Content", with: <<~MARKDOWN
      # Welcome to the newsletter

      OMG! This is the first newsletter.
    MARKDOWN

    click_button "Update Newsletter"

    expect(page).to have_content("Newsletter was successfully updated.")

    expect(page).to have_content("OMG! This is the first newsletter.")
  end

  it "send a newsletter test", :vcr do
    newsletter = FactoryBot.create(:newsletter)
    test_recipient_email = Rails.configuration.settings.emails.test_recipient
    FactoryBot.create(:user, :confirmed, :subscribed, email: test_recipient_email)

    allow(PostmarkClient).to receive(:deliver_messages).and_call_original

    login_as_admin

    visit admin_newsletters_path

    click_link newsletter.title

    click_button "Send Test"

    expect(page).to have_content("[TEST] Newsletter was successfully delivered.")

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    expect(PostmarkClient).to have_received(:deliver_messages) do |messages|
      expect(messages.size).to eq(1)

      mail = messages.first
      expect(mail.to).to eq([test_recipient_email])
      expect(mail.subject).to eq(newsletter.title)
    end
  end

  it "send a newsletter live", :vcr do
    newsletter = FactoryBot.create(:newsletter)

    unconfirmed = FactoryBot.create_list(:user, 2, :unconfirmed)
    nonsubscribers = FactoryBot.create_list(:user, 2, :confirmed, :unsubscribed)
    subscribers = FactoryBot.create_list(:user, 2, :confirmed, :subscribed)

    allow(PostmarkClient).to receive(:deliver_messages).and_call_original

    login_as_admin

    visit admin_newsletters_path

    click_link newsletter.title

    click_button "Send Live"

    expect(page).to have_content("[LIVE] Newsletter was successfully delivered.")

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    expect(PostmarkClient).to have_received(:deliver_messages) do |messages|
      expect(messages.size).to eq(2)

      delivered_emails = messages.flat_map(&:to).sort

      expect(delivered_emails).to eq(subscribers.map(&:email).sort)
      (unconfirmed + nonsubscribers).map(&:email).each do |email|
        expect(delivered_emails).not_to include(email)
      end

      mail = messages.first

      expect(mail.subject).to eq(newsletter.title)
    end
  end
end
