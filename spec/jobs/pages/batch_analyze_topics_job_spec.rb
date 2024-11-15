require "rails_helper"

RSpec.describe Pages::BatchAnalyzeTopicsJob, type: :job do
  it "doesn’t blow up" do
    allow(SitepressPage).to receive(:render_html).and_return(Faker::HTML.random)

    topics = FactoryBot.create_list(:topic, 2)

    page_1, page_2, page_3 = Page.upsert_collection_from_sitepress!(limit: 3).each do |page|
      page.touch(:published_at)
    end

    # articles without topics
    page_1.update!(topics: [])
    page_2.update!(topics: [])

    # articles with topics
    page_3.update!(topics: topics)

    # not articles
    FactoryBot.create_list(:page, 3)

    expect(Pages::AnalyzeTopicsJob).to receive(:perform_later).exactly(2).times

    described_class.perform_now
  end
end
