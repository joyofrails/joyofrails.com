require "rails_helper"

RSpec.describe Pages::BatchAnalyzeTopicsJob, type: :job do
  it "doesn’t blow up" do
    allow(SitepressPage).to receive(:render_html).and_return(Faker::HTML.random)

    topics = FactoryBot.create_list(:topic, 2)

    # articles without topics
    Page.find_or_create_by!(request_path: "/articles/custom-color-schemes-with-ruby-on-rails")
    Page.find_or_create_by!(request_path: "/articles/mastering-custom-configuration-in-rails")

    # articles with topics
    Page.find_or_create_by!(request_path: "/articles/web-push-notifications-from-rails")
      .update!(topics: topics)

    # not articles
    FactoryBot.create_list(:page, 3)

    expect(Pages::AnalyzeTopicsJob).to receive(:perform_later).exactly(2).times

    described_class.perform_now
  end
end
