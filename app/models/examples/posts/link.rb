# == Schema Information
#
# Table name: examples_posts_links
#
#  id         :integer          not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Examples::Posts::Link < ApplicationRecord
end
