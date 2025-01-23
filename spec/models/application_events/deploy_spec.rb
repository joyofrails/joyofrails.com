require "rails_helper"

RSpec.describe ApplicationEvents::Deploy do
  describe "#validations" do
    it { expect(described_class.new(data: {sha: "123"})).to be_valid }
    it { expect(described_class.new(data: {sha: nil})).not_to be_valid }
    it { expect(described_class.new).not_to be_valid }
  end
end
