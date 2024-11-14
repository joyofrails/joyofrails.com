# == Schema Information
#
# Table name: newsletters
#
#  id         :string           not null, primary key
#  content    :text             not null
#  sent_at    :datetime
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_newsletters_on_sent_at  (sent_at)
#
class Newsletter < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  scope :sent, -> { where.not(sent_at: nil).order(sent_at: :desc) }
end
