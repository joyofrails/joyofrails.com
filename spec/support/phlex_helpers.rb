module PhlexHelpers
  def render_component(*, **, &)
    render(described_class.new(*, **, &))
  end
end

RSpec.configure do |config|
  config.include PhlexHelpers, type: :view

  config.before(:each, type: :view) do
    allow(view).to receive(:headers).and_return({"Content-Type" => "text/html"})
  end
end
