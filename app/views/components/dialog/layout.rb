module Dialog
  class Layout < ApplicationComponent
    include PhlexConcerns::SvgTag

    attr_reader :attributes

    def initialize(**attributes)
      @attributes = attributes
    end

    def view_template(&)
      dialog(**mix(attributes, class: "rounded-lg drop-shadow-xl p-xl")) do
        div(class: "flex min-h-full flex-col justify-center relative grid-gap", &)
      end
    end

    def header(&)
      super(class: "w-full max-w-sm text-theme", &)
    end

    def feature_img(**attributes)
      img(**mix(attributes, class: "fill-current mx-auto"))
    end

    def title(**attributes, &)
      h2(**mix(attributes, class: "mt-4 text-center text-2xl text-theme font-bold leading-9 tracking-tight"), &)
    end

    def body(&)
      div(class: "w-full max-w-sm", &)
    end

    def close_button
      form(method: :dialog) do
        button(aria_label: "close", class: "absolute right-0", style: "width:24px;") do
          svg_tag "close.svg", class: "fill-current", style: "max-width: 24px;", alt: "Close"
        end
      end
    end
  end
end
