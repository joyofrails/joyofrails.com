require "rails_helper"

RSpec.describe "/admin/newsletters", type: :request do
  let(:valid_attributes) { FactoryBot.attributes_for(:newsletter) }
  let(:invalid_attributes) { {title: "", content: ""} }

  describe "GET /" do
    it "renders a successful response" do
      FactoryBot.create(:newsletter)

      get admin_newsletters_path

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      newsletter = FactoryBot.create(:newsletter)

      get admin_newsletter_path(newsletter)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_admin_newsletter_path

      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      newsletter = FactoryBot.create(:newsletter)

      get edit_admin_newsletter_path(newsletter)

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Newsletter" do
        expect {
          post admin_newsletters_path, params: {newsletter: valid_attributes}
        }.to change(Newsletter, :count).by(1)
      end

      it "redirects to the created admin_newsletter" do
        post admin_newsletters_path, params: {newsletter: valid_attributes}
        expect(response).to redirect_to(admin_newsletter_path(Newsletter.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Newsletter" do
        expect {
          post admin_newsletters_path, params: {newsletter: invalid_attributes}
        }.to change(Newsletter, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post admin_newsletters_path, params: {newsletter: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { {title: "A New Title"} }

      it "updates the requested admin_newsletter" do
        newsletter = FactoryBot.create(:newsletter)
        patch admin_newsletter_path(newsletter), params: {newsletter: new_attributes}
        newsletter.reload
        expect(newsletter.title).to eq("A New Title")
      end

      it "redirects to the admin_newsletter" do
        newsletter = FactoryBot.create(:newsletter)
        patch admin_newsletter_path(newsletter), params: {newsletter: new_attributes}
        newsletter.reload
        expect(response).to redirect_to(admin_newsletter_path(newsletter))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        newsletter = FactoryBot.create(:newsletter)
        patch admin_newsletter_path(newsletter), params: {newsletter: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /deliver" do
    before do
      allow(PostmarkClient).to receive(:deliver_messages)
    end

    context "with no parameters" do
      before do
        FactoryBot.create(:user, :confirmed, :subscribed, email: ApplicationMailer.test_recipients.first)
        FactoryBot.create_list(:user, 2, :confirmed, :subscribed)
      end

      it "sends test email" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter)
        perform_enqueued_jobs_and_subsequently_enqueued_jobs
        newsletter.reload
        expect(newsletter.sent_at).to be_blank
        expect(PostmarkClient).to have_received(:deliver_messages) do |messages|
          expect(messages.size).to eq(1)
          expect(messages.first.to).to eq(User.test_recipients.map(&:email))
        end
      end

      it "redirects to the admin_newsletter" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter)
        newsletter.reload
        expect(response).to redirect_to(admin_newsletter_path(newsletter))
      end
    end

    context "with live parameter" do
      before do
        FactoryBot.create_list(:user, 2, :confirmed, :subscribed)
      end

      it "sends emails to subscribers" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter), params: {live: "true"}
        perform_enqueued_jobs_and_subsequently_enqueued_jobs
        newsletter.reload
        expect(newsletter.sent_at).to be_present
        expect(PostmarkClient).to have_received(:deliver_messages) do |messages|
          expect(messages.size).to eq(2)
          expect(messages.flat_map(&:to)).to eq(User.subscribers.map(&:email))
        end
      end

      it "redirects to the admin_newsletter" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter), params: {live: "true"}
        newsletter.reload
        expect(response).to redirect_to(admin_newsletter_path(newsletter))
      end
    end

    context "with no recipients" do
      it "does not send any emails" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter), params: {live: "true"}
        perform_enqueued_jobs_and_subsequently_enqueued_jobs
        newsletter.reload
        expect(PostmarkClient).not_to have_received(:deliver_messages)
      end

      it "redirects to the admin_newsletter" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter), params: {live: "true"}
        newsletter.reload
        expect(response).to redirect_to(admin_newsletter_path(newsletter))
      end
    end

    context "newsletter is already sent" do
      before do
        FactoryBot.create_list(:user, 2, :subscribed)
      end

      it "does not send any emails" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter), params: {live: "true"}
        perform_enqueued_jobs_and_subsequently_enqueued_jobs
        newsletter.reload
        expect(PostmarkClient).not_to have_received(:deliver_messages)
      end

      it "redirects to the admin_newsletter" do
        newsletter = FactoryBot.create(:newsletter)
        patch deliver_admin_newsletter_path(newsletter), params: {live: "true"}
        newsletter.reload
        expect(response).to redirect_to(admin_newsletter_path(newsletter))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested admin_newsletter" do
      newsletter = FactoryBot.create(:newsletter)
      expect {
        delete admin_newsletter_path(newsletter)
      }.to change(Newsletter, :count).by(-1)
    end

    it "redirects to the admin_newsletters list" do
      newsletter = FactoryBot.create(:newsletter)
      delete admin_newsletter_path(newsletter)
      expect(response).to redirect_to(admin_newsletters_path)
    end
  end
end
