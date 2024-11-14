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
class Notification < ApplicationRecord
  belongs_to :notification_event, counter_cache: true
  belongs_to :recipient, polymorphic: true

  scope :newest_first, -> { order(created_at: :desc) }

  delegate :params, :record, to: :event

  scope :processed, -> { where.not(processed_at: nil) }
end
