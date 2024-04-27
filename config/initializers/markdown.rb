ActionView::Template.register_template_handler :md, ->(template, source) {
  Markdown::Application::Handler.call(template, source)
}

ActionView::Template.register_template_handler :"md-erb", ->(template, source) {
  Markdown::Erb::Handler.call(template, source)
}
