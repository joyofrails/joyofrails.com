# == Schema Information
#
# Table name: polls_votes
#
#  id          :integer          not null, primary key
#  device_uuid :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  answer_id   :integer          not null
#  user_id     :string
#
# Indexes
#
#  index_polls_votes_on_answer_id    (answer_id)
#  index_polls_votes_on_device_uuid  (device_uuid)
#  index_polls_votes_on_user_id      (user_id)
#
# Foreign Keys
#
#  answer_id  (answer_id => polls_answers.id)
#  user_id    (user_id => users.id)
#
require "rails_helper"

RSpec.describe Polls::Vote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end