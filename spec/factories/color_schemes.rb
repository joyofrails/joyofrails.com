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
