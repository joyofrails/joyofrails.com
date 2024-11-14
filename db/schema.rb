# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_14_213838) do
  create_table "_litestream_lock", id: false, force: :cascade do |t|
    t.integer "id"
  end

  create_table "_litestream_seq", force: :cascade do |t|
    t.integer "seq"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.string "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "color_schemes", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "weight_50", null: false
    t.string "weight_100", null: false
    t.string "weight_200", null: false
    t.string "weight_300", null: false
    t.string "weight_400", null: false
    t.string "weight_500", null: false
    t.string "weight_600", null: false
    t.string "weight_700", null: false
    t.string "weight_800", null: false
    t.string "weight_900", null: false
    t.string "weight_950", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_color_schemes_on_name", unique: true
  end

  create_table "email_exchanges", force: :cascade do |t|
    t.string "email", null: false
    t.string "user_id", null: false
    t.string "status", default: "0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "email"], name: "index_email_exchanges_on_user_id_and_email", unique: true, where: "status = 0"
    t.index ["user_id"], name: "index_email_exchanges_on_user_id"
  end

  create_table "examples_posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "postable_type", null: false
    t.integer "postable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postable_type", "postable_id"], name: "index_examples_posts_on_postable"
  end

  create_table "examples_posts_images", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "examples_posts_links", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "examples_posts_markdowns", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "newsletter_subscriptions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "subscriber_type", null: false
    t.string "subscriber_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_type", "subscriber_id"], name: "index_newsletter_subscriptions_on_subscriber", unique: true
  end

  create_table "newsletters", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sent_at"], name: "index_newsletters_on_sent_at"
  end

  create_table "notification_events", force: :cascade do |t|
    t.string "type"
    t.json "params"
    t.integer "notifications_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "type"
    t.integer "notification_event_id", null: false
    t.string "recipient_type", null: false
    t.string "recipient_id", null: false
    t.datetime "read_at"
    t.datetime "seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "processed_at"
    t.index ["notification_event_id"], name: "index_notifications_on_notification_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "page_topics", force: :cascade do |t|
    t.string "page_id", null: false
    t.integer "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id", "topic_id"], name: "index_page_topics_on_page_id_and_topic_id", unique: true
    t.index ["page_id"], name: "index_page_topics_on_page_id"
    t.index ["topic_id"], name: "index_page_topics_on_topic_id"
  end

  create_table "pages", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "request_path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.datetime "indexed_at"
    t.index ["indexed_at"], name: "index_pages_on_indexed_at"
    t.index ["published_at"], name: "index_pages_on_published_at"
    t.index ["request_path"], name: "index_pages_on_request_path", unique: true
  end

  create_table "snippets", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.text "source", null: false
    t.string "filename"
    t.string "language"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author_type", null: false
    t.string "author_id", null: false
    t.string "title"
    t.index ["author_type", "author_id"], name: "index_snippets_on_author"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug", null: false
    t.string "status", default: "pending", null: false
    t.integer "pages_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pages_count"], name: "index_topics_on_pages_count"
    t.index ["slug"], name: "index_topics_on_slug", unique: true
    t.index ["status"], name: "index_topics_on_status"
  end

  create_table "users", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.datetime "last_sign_in_at"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "email_exchanges", "users"
  add_foreign_key "notifications", "notification_events"
  add_foreign_key "page_topics", "pages"
  add_foreign_key "page_topics", "topics"

  # Virtual tables defined in this database.
  # Note that virtual tables may not work with other database engines. Be careful if changing database.
  create_virtual_table "pages_search_index", "fts5", ["title", "body", "page_id"]
end
