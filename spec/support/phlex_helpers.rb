RSpec.configure do |config|
  config.before(:each, type: :view) do
    allow(view).to receive(:headers).and_return({"Content-Type" => "text/html"})
  end
end
