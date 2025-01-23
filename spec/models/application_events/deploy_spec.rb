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
# Indexes
#
#  index_application_events_on_created_at  (created_at)
#
require "rails_helper"

RSpec.describe ApplicationEvents::Deploy do
  describe "#validations" do
    it { expect(described_class.new(data: {sha: "123"})).to be_valid }
    it { expect(described_class.new(data: {sha: nil})).not_to be_valid }
    it { expect(described_class.new).not_to be_valid }
  end
end
