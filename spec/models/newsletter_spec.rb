require "rails_helper"

RSpec.describe Newsletter, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:newsletter)).to be_valid
  end
end
