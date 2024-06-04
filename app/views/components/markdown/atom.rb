# DANGER! This parses Erb, which means arbitrary Ruby can be run. Make sure
# you trust the source of your markdown and that its not user input.

class Markdown::Atom < Markdown::Application
  prepend Markdown::AllowsErb
end
