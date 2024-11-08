module Searches
  class Result < ApplicationComponent
    class_attribute :result_classes
    self.result_classes = {}

    def self.register(result_class, component_class)
      result_classes[result_class] = component_class
    end

    def self.lookup_component_class(result)
      component_class = result_classes[result.class]

      if !component_class
        component_class = "Searches::Results::#{result.class.name}".safe_constantize
        register(result.class, component_class) if component_class
      end

      raise ArgumentError, "[#{self}] No component registered for #{result.class}" unless component_class

      component_class
    end

    attr_reader :result, :component_class

    def initialize(result)
      @result = result

      @component_class = self.class.lookup_component_class(result)
    end

    def view_template
      render component_class.new(result)
    end
  end
end
