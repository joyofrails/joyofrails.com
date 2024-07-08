require "rails_helper"

RSpec.describe Color do
  describe "#==" do
    it { expect(Color.new("#ffffff")).to eq(Color.new("#ffffff")) }
    it { expect(Color.new("#000000")).to eq(Color.new("#000000")) }

    it { expect(Color.new("#ffffff")).not_to eq(Color.new("#000000")) }

    it { expect(Color.new("#ffffff")).not_to eq(nil) }
    it { expect(Color.new("#ffffff")).not_to eq("#ffffff") }
  end
end
