# == Schema Information
#
# Table name: polls_questions
#
#  id         :integer          not null, primary key
#  body       :string           not null
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poll_id    :string           not null
#
# Indexes
#
#  index_polls_questions_on_poll_id  (poll_id)
#
# Foreign Keys
#
#  poll_id  (poll_id => polls.id)
#
require "rails_helper"

RSpec.describe Polls::Question, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
