class NotificationEvent < ApplicationRecord
  class Coder
    def self.load(data)
      return if data.nil?
      ActiveJob::Arguments.send(:deserialize_argument, data)
    rescue ActiveRecord::RecordNotFound => error
      {error: error.message, original_params: data}
    end

    def self.dump(data)
      return if data.nil?
      ActiveJob::Arguments.send(:serialize_argument, data)
    end
  end

  has_many :notifications, dependent: :delete_all
  has_many :recipients, through: :notifications, source: :recipient, source_type: "User"

  accepts_nested_attributes_for :notifications

  scope :newest_first, -> { order(created_at: :desc) }

  attribute :params, :json, default: {}

  serialize :params, coder: Coder

  # Defined a subclass of Notification for each subclass of NotificationEvent
  def self.inherited(notifier)
    super
    notifier.const_set :Notification, Class.new(Notification)
  end

  def deliver_to?(recipient)
    true
  end

  # CommentNotifier.deliver(User.all)
  # CommentNotifier.deliver(User.all, priority: 10)
  # CommentNotifier.deliver(User.all, queue: :low_priority)
  # CommentNotifier.deliver(User.all, wait: 5.minutes)
  # CommentNotifier.deliver(User.all, wait_until: 1.hour.from_now)
  def deliver(given_recipients = nil, enqueue_job: true, **options)
    validate!

    recipients = Array.wrap(given_recipients)

    transaction do
      recipients_attributes = recipients.map do |recipient|
        recipient_attributes_for(recipient)
      end

      self.notifications_count = recipients_attributes.size
      save!

      notifications.insert_all!(recipients_attributes, record_timestamps: true) if recipients_attributes.any?
    end

    # Enqueue delivery job
    Notifications::EventJob.set(options).perform_later(self) if enqueue_job

    self
  end
  alias_method :deliver_later, :deliver

  def recipient_attributes_for(recipient)
    {
      type: "#{self.class.name}::Notification",
      recipient_type: recipient.class.base_class.name,
      recipient_id: recipient.id
    }
  end

  def deliver_notifications_in_bulk
    # no op
  end

  def deliver_notification(notification)
    # no op
  end
end
