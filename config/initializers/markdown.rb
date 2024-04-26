ActionView::Template.register_template_handler :md, ->(template, source) {
  ApplicationMarkdown::Handler.call(template, source)
}

ActionView::Template.register_template_handler :"md-erb", ->(template, source) {
  ErbMarkdown::Handler.call(template, source)
}
