class Topic < ApplicationRecord
  include Sluggable

  slug_from :name

  has_many :page_topics
  has_many :pages, through: :page_topics

  validates :name, presence: true, uniqueness: true

  normalizes :name, with: ->(name) { name.squish }

  scope :with_pages, -> { where("pages_count >= 1") }
  scope :without_pages, -> { where(pages_count: 0) }
  scope :with_n_pages, ->(n) { where("pages_count = ?", n) }

  enum :status, %w[pending approved rejected duplicate].index_by(&:itself)

  after_update :remove_page_topics, if: :rejected?

  def self.create_from_list(topics, status: "pending")
    topics.uniq.map! { |name|
      Topic.find_or_create_by(name:) do |t|
        t.status = status
      end
    }
  end

  def remove_page_topics
    page_topics.destroy_all
  end
end
