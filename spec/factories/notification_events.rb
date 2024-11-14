# == Schema Information
#
# Table name: notification_events
#
#  id                  :integer          not null, primary key
#  notifications_count :integer          default(0)
#  params              :json
#  type                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :notification_event do
  end
end
