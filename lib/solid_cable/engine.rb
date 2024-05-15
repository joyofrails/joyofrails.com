# frozen_string_literal: true

module SolidCable
  class Engine < ::Rails::Engine
    isolate_namespace SolidCable

    # Engine configuration moved to initializer to allow for
    # lazy loading in development

    # config.solid_cable = ActiveSupport::OrderedOptions.new

    # initializer "solid_cable.config" do
    #   config.solid_cable.each do |name, value|
    #     SolidCable.public_send(:"#{name}=", value)
    #   end
    # end
  end
end
