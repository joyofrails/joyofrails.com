# == Schema Information
#
# Table name: page_polls
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  page_id    :string           not null
#  poll_id    :string           not null
#
# Indexes
#
#  index_page_polls_on_page_id              (page_id)
#  index_page_polls_on_page_id_and_poll_id  (page_id,poll_id) UNIQUE
#  index_page_polls_on_poll_id              (poll_id)
#
# Foreign Keys
#
#  page_id  (page_id => pages.id)
#  poll_id  (poll_id => polls.id)
#
class PagePoll < ApplicationRecord
  belongs_to :page
  belongs_to :poll
end
