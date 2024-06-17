class Notification < ApplicationRecord
  belongs_to :notification_event, counter_cache: true
  belongs_to :recipient, polymorphic: true

  scope :newest_first, -> { order(created_at: :desc) }

  delegate :params, :record, to: :event
end
