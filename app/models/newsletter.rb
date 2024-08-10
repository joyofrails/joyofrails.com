class Newsletter < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  scope :sent, -> { where.not(sent_at: nil).order(sent_at: :desc) }
end
