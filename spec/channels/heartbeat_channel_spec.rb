require "rails_helper"

RSpec.describe HeartbeatChannel, type: :channel do
  it "successfully subscribes user" do
    stub_connection(current_user: FactoryBot.create(:user))

    subscribe room_id: 42
    expect(subscription).to be_confirmed
  end

  it "successfully subscribes guest" do
    stub_connection(current_user: Guest.new)

    subscribe room_id: 42
    expect(subscription).to be_confirmed
  end
end
