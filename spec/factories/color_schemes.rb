# == Schema Information
#
# Table name: color_schemes
#
#  id         :string           not null, primary key
#  name       :string           not null
#  weight_100 :string           not null
#  weight_200 :string           not null
#  weight_300 :string           not null
#  weight_400 :string           not null
#  weight_50  :string           not null
#  weight_500 :string           not null
#  weight_600 :string           not null
#  weight_700 :string           not null
#  weight_800 :string           not null
#  weight_900 :string           not null
#  weight_950 :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_color_schemes_on_name  (name) UNIQUE
#
require "faker"

FactoryBot.define do
  factory :color_scheme do
    sequence(:name) { |n| "#{Faker::Color.color_name.titleize} #{n}" }
    weight_50 { Color.new Faker::Color.hex_color }
    weight_100 { Color.new Faker::Color.hex_color }
    weight_200 { Color.new Faker::Color.hex_color }
    weight_300 { Color.new Faker::Color.hex_color }
    weight_400 { Color.new Faker::Color.hex_color }
    weight_500 { Color.new Faker::Color.hex_color }
    weight_600 { Color.new Faker::Color.hex_color }
    weight_700 { Color.new Faker::Color.hex_color }
    weight_800 { Color.new Faker::Color.hex_color }
    weight_900 { Color.new Faker::Color.hex_color }
    weight_950 { Color.new Faker::Color.hex_color }
  end
end
