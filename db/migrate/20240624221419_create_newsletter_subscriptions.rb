class CreateNewsletterSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :newsletter_subscriptions, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.references :subscriber, polymorphic: true, index: false, null: false, type: :string
      t.timestamps
    end

    add_index :newsletter_subscriptions, [:subscriber_type, :subscriber_id], unique: true, name: "index_newsletter_subscriptions_on_subscriber"
  end
end
