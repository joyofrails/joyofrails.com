# == Schema Information
#
# Table name: newsletters
#
#  id         :string           not null, primary key
#  content    :text             not null
#  sent_at    :datetime
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_newsletters_on_sent_at  (sent_at)
#
require "rails_helper"

RSpec.describe Newsletter, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:newsletter)).to be_valid
  end
end
