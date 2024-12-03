require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  it "successfully connects logged-in user" do
    user = instance_double(User, id: "323")
    connect "/cable", env: {"warden" => double(user: user)}
    expect(connection.current_user).to eq user
  end

  it "successfully connects guest user" do
    connect "/cable"
    expect(connection.current_user).to be_a(Guest)
  end

  # For future reference:
  # it "rejects connection" do
  #   expect { connect "/cable", env: {} }.to have_rejected_connection
  # end
end
