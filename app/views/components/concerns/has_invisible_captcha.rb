module Concerns::HasInvisibleCaptcha
  extend ActiveSupport::Concern

  included do
    # The following modules are needed to make Phlex components work with invisible_captcha
    include InvisibleCaptcha::ViewHelpers
    include Phlex::Rails::Helpers::ContentTag
    include Phlex::Rails::Helpers::Request
    include Phlex::Rails::Helpers::LabelTag
    include Phlex::Rails::Helpers::TextFieldTag
    include Phlex::Rails::Helpers::HiddenFieldTag

    extend Phlex::Rails::HelperMacros
    # @!method session(...)
    register_value_helper :session
    # @!method concat(...)
    register_value_helper :concat
  end
end
