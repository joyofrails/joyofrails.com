# == Schema Information
#
# Table name: application_events
#
#  id         :string           not null, primary key
#  data       :text             not null
#  metadata   :text
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_application_events_on_created_at  (created_at)
#
class ApplicationEvent < ApplicationRecord
  serialize :data, coder: JSON
  serialize :metadata, coder: JSON
end
