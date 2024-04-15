module InlineSvg
  module ActionView
    module Helpers
      def inline_svg_tag(...) = "<svg></svg>".html_safe
    end
  end
end

module InlineSvg
  class Railtie < ::Rails::Railtie
    initializer "inline_svg.action_view" do |app|
      ActiveSupport.on_load :action_view do
        include InlineSvg::ActionView::Helpers
      end
    end
  end
end
