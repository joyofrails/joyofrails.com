require "webmock/rspec"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before(:each) do
    WebMock.disable_net_connect!(
      allow_localhost: true,
      allow: [
        "chromedriver.storage.googleapis.com",
        %r{w3.org/}
      ]
    )
  end

  config.around do |example|
    if example.metadata.key?(:vcr)
      example.run
    else
      VCR.turned_off { example.run }
    end
  end
end
