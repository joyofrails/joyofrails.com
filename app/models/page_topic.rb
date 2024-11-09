class PageTopic < ApplicationRecord
  belongs_to :page
  belongs_to :topic, counter_cache: :pages_count

  def reset_topic_counter_cache
    Topic.reset_counters(topic_id, :pages)
  end
end
