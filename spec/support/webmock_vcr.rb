require "webmock/rspec"
require "vcr"

module WebmockHelpers
  def json_response(body, **attrs)
    {
      status: 200,
      body: body.to_json,
      headers: {"Content-Type" => "application/json"}.merge(attrs.slice(:headers))
    }.merge(attrs.except(:headers))
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<AUTHORIZATION>") { |interaction| Array(interaction.request.headers["Authorization"]).first }
end

RSpec.configure do |config|
  config.include WebmockHelpers

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
