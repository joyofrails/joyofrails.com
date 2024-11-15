RSpec.configure do |config|
  config.when_first_matching_example_defined(type: :task) do
    Rails.application.load_tasks
  end
end
