require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  it "successfully connects" do
    admin = instance_double(AdminUser, id: "323")
    connect "/cable", env: {"warden" => double(user: admin)}
    expect(connection.current_admin_user).to eq admin
  end

  it "rejects connection" do
    expect { connect "/cable", env: {} }.to have_rejected_connection
  end
end
