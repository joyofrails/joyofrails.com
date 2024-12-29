snippet_count = 20
snippet_fill_count = snippet_count - Snippet.count
user = User.first
require 'factory_bot'
require 'faker'
require_relative '../../../spec/factories/snippets'
FactoryBot.create_list(:snippet, snippet_fill_count, author: user) if snippet_fill_count > 0
