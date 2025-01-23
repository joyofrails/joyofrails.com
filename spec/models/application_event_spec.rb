# == Schema Information
#
# Table name: application_events
#
#  id         :string           not null, primary key
#  data       :text             not null
#  metadata   :text
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe ApplicationEvent, type: :model do
  before do
    ::TestEvent = Class.new(described_class)
  end

  after do
    Object.send(:remove_const, :TestEvent)
  end

  it "treats data as JSON" do
    event = FactoryBot.create(:application_event, type: TestEvent, data: {wibble: "wobble"})

    expect(event.data).to eq("wibble" => "wobble")
  end

  it "treats metadata as JSON" do
    event = FactoryBot.create(:application_event, type: TestEvent, metadata: {fizzle: "fozzle"})

    expect(event.metadata).to eq("fizzle" => "fozzle")
  end
end
