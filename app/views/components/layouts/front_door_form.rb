class Layouts::FrontDoorForm < Phlex::HTML
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::FieldsFor
  include Phlex::Rails::Helpers::Label
  include Phlex::Rails::Helpers::Object
  include Phlex::Rails::Helpers::Routes
  include PhlexConcerns::SvgTag

  def initialize(title:)
    @title = title
  end

  def view_template(&)
    form_layout(&)
  end

  def form_layout(&block)
    div(class: "flex min-h-full flex-col justify-center container py-xl lg:px-3xl") do
      div(class: "mx-auto w-full max-w-sm text-theme") do
        svg_tag "joy-logo.svg",
          class: "fill-current mx-auto",
          style: "max-width: 64px;",
          alt: "Joy of Rails"
        h2(
          class: "mt-4 text-center text-2xl text-theme font-bold leading-9 tracking-tight"
        ) { @title }
      end
      div(class: "mx-auto w-full max-w-sm", &block)
    end
  end

  def form_with(**, &)
    super(class: "grid grid-row-tight", **, &)
  end

  def form_label(form, *args, **opts)
    div(class: "flex items-center justify-between") do
      plain form.label(*args, class: "block text-sm font-medium leading-6", **opts)
    end
  end

  def form_field(form, method, *args, **opts)
    div(class: "mt-2") do
      plain form.send(
        method,
        *args,
        class: "block w-full rounded-md py-1.5 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6",
        **opts
      )
    end
  end

  def form_button(form, text)
    div(class: "pt-6") do
      plain form.button text,
        type: :submit,
        class:
          "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
    end
  end
end
