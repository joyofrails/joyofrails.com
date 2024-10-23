require "rails_helper"

RSpec.describe "Newsletters", type: :system do
  it "renders empty list" do
    visit newsletters_path

    expect(page).to have_content("No newsletters")
  end

  it "renders list of published newsletters" do
    unsent = FactoryBot.create_list(:newsletter, 2)
    sent = FactoryBot.create_list(:newsletter, 2, :sent)

    visit newsletters_path

    sent.each do |newsletter|
      expect(page).to have_content(newsletter.title)
    end
    unsent.each do |newsletter|
      expect(page).not_to have_content(newsletter.title)
    end

    click_link sent.first.title

    first_line_as_text = sent.first.content.split("\n").first.gsub(/[^\w]+/, "")
    expect(page).to have_content(first_line_as_text)
  end
end
