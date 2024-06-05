require "rails_helper"

RSpec.describe User, type: :model do
  it "can create a user" do
    expect(User.create(email: "hello@joyofrails.com")).to be_persisted
  end

  it "generates a confirmation token" do
    user = FactoryBot.create(:user)
    token = user.generate_token_for(:confirmation)
    # token can be used to lookup user with User.find_by_token_for(:confirmation, token)
    expect(token).to be_present
  end
end
