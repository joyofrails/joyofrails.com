# == Schema Information
#
# Table name: notifications
#
#  id                    :integer          not null, primary key
#  processed_at          :datetime
#  read_at               :datetime
#  recipient_type        :string           not null
#  seen_at               :datetime
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  notification_event_id :integer          not null
#  recipient_id          :string           not null
#
# Indexes
#
#  index_notifications_on_notification_event_id  (notification_event_id)
#  index_notifications_on_recipient              (recipient_type,recipient_id)
#
# Foreign Keys
#
#  notification_event_id  (notification_event_id => notification_events.id)
#
FactoryBot.define do
  factory :notification do
  end
end
