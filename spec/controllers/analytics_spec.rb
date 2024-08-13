require "rails_helper"

RSpec.describe "Analytics", type: :controller do
  controller do
    include Analytics

    after_action do
      plausible_event "Something Happened", props: {value: 42}
    end

    def index
      render plain: "Hello, World!"
    end
  end

  it "sends a plausible event" do
    plausible_request = stub_request(:post, "https://plausible.io/api/event")

    get :index

    perform_enqueued_jobs

    expect(plausible_request).to have_been_requested
  end
end
