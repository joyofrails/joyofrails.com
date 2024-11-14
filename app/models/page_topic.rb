# == Schema Information
#
# Table name: page_topics
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  page_id    :string           not null
#  topic_id   :integer          not null
#
# Indexes
#
#  index_page_topics_on_page_id               (page_id)
#  index_page_topics_on_page_id_and_topic_id  (page_id,topic_id) UNIQUE
#  index_page_topics_on_topic_id              (topic_id)
#
# Foreign Keys
#
#  page_id   (page_id => pages.id)
#  topic_id  (topic_id => topics.id)
#
class PageTopic < ApplicationRecord
  belongs_to :page
  belongs_to :topic, counter_cache: :pages_count

  def reset_topic_counter_cache
    Topic.reset_counters(topic_id, :pages)
  end
end
