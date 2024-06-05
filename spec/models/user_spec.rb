require "rails_helper"

RSpec.describe User, type: :model do
  it "can create a user" do
    expect(User.create(email: "hello@joyofrails.com")).to be_persisted
  end
end
