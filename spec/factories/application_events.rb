FactoryBot.define do
  factory :application_event do
    data { {key: "value"}.to_json }
    metadata { {info: "details"}.to_json }
  end
end
