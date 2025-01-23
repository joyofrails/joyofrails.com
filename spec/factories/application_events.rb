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
FactoryBot.define do
  factory :application_event do
    data { {key: "value"}.to_json }
    metadata { {info: "details"}.to_json }
  end
end
