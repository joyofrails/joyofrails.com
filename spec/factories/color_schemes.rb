require "faker"

FactoryBot.define do
  factory :color_scheme do
    sequence(:name) { |n| "#{Faker::Color.color_name.titleize} #{n}" }
    weight_50 { Faker::Color.hex_color }
    weight_100 { Faker::Color.hex_color }
    weight_200 { Faker::Color.hex_color }
    weight_300 { Faker::Color.hex_color }
    weight_400 { Faker::Color.hex_color }
    weight_500 { Faker::Color.hex_color }
    weight_600 { Faker::Color.hex_color }
    weight_700 { Faker::Color.hex_color }
    weight_800 { Faker::Color.hex_color }
    weight_900 { Faker::Color.hex_color }
    weight_950 { Faker::Color.hex_color }
  end
end
