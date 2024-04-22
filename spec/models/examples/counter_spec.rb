require "rails_helper"

RSpec.describe Examples::Counter, type: :model do
  subject { described_class.new(count: 0) }

  it { expect(subject.count).to eq(0) }

  it "increments the count" do
    subject.assign_attributes(count: 1)
    expect(subject.count).to eq(1)
  end
end
