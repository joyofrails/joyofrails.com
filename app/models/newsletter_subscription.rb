# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id              :string           not null, primary key
#  subscriber_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  subscriber_id   :string           not null
#
# Indexes
#
#  index_newsletter_subscriptions_on_subscriber  (subscriber_type,subscriber_id) UNIQUE
#
class NewsletterSubscription < ApplicationRecord
  belongs_to :subscriber, polymorphic: true, inverse_of: :newsletter_subscription

  generates_token_for :unsubscribe do
    subscriber.email
  end
end
