require "rails_helper"

RSpec.describe HeartbeatChannel, type: :channel do
  it "successfully subscribes" do
    stub_connection(current_admin_user: FactoryBot.create(:admin_user))

    subscribe room_id: 42
    expect(subscription).to be_confirmed
  end
end
