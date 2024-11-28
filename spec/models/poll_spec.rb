# == Schema Information
#
# Table name: polls
#
#  id         :string           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :string           not null
#
# Indexes
#
#  index_polls_on_author_id  (author_id)
#  index_polls_on_title      (title)
#
# Foreign Keys
#
#  author_id  (author_id => users.id)
#
require "rails_helper"

RSpec.describe Poll, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
