require "factory_bot_rails"

snippet_count = 20
snippet_fill_count = snippet_count - Snippet.count
user = User.first

FactoryBot.create_list(:snippet, snippet_fill_count, author: user) if snippet_fill_count > 0
