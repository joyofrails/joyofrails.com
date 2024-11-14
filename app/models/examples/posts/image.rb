# == Schema Information
#
# Table name: examples_posts_images
#
#  id         :integer          not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Examples::Posts::Image < ApplicationRecord
end
