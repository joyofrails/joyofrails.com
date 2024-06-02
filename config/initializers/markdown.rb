ActionView::Template.register_template_handler :md, ->(template, source) {
  Markdown::Application.new(source).call
}

ActionView::Template.register_template_handler :mdrb, ->(template, source) {
  Markdown::AllowsErb::Handler.new(Markdown::Article).call(template, source)
}

ActionView::Template.register_template_handler :"mdrb-atom", ->(template, source) {
  Markdown::AllowsErb::Handler.new(Markdown::Atom).call(template, source)
}
