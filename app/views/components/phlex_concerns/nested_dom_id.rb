module PhlexConcerns
  module NestedDomId
    include Phlex::Rails::Helpers::DOMID

    def nested_dom_id(*args)
      args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
    end
  end
end
