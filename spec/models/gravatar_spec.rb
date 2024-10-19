require "rails_helper"

RSpec.describe Gravatar do
  let(:email) { Faker::Internet.email }

  it "should return the gravatar url" do
    expect(Gravatar.new(email).url).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=32&d=retro")
  end
end
