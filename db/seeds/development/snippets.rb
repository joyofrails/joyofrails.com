snippet_count = 10
snippet_fill_count = snippet_count - Snippet.count
FactoryBot.create_list(:snippet, snippet_fill_count) if snippet_fill_count > 0
