# frozen_string_literal: true

class ApplicationComponent < Phlex::HTML
  include Phlex::Rails::Helpers::Routes
  include PhlexConcerns::Links

  register_value_helper :user_signed_in?
  register_value_helper :current_user
  register_value_helper :asset_path

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end

  def markdown
    render Markdown::Application.new(yield)
  end
end
