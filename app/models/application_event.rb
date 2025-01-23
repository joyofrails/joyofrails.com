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
class ApplicationEvent < ApplicationRecord
  serialize :data, coder: JSON
  serialize :metadata, coder: JSON
end
