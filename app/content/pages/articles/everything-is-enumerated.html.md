---
title: Everything is Enumerated
author: Ross Kaffenberger
published: 2018-12-21
summary: Using to_enum with block methods
description: This post describes how to make enumerable methods that use blocks to iterate over an internal data structures but don't their enumerable properties and why this would be useful.
thumbnail: 'blog/stock/chutternsnap-containers-unsplash.jpg'
thumbnail_caption: Photo by chuttersnap on Unsplash
series: Enumerable
category: Code
layout: article
tags:
  - Rails
  - Ruby
---

In Ruby, some methods expect a block as a callback yielding elements of some internal data structure.

Imagine a method `paginated_results` on some `client` object that yields individual pages.

```ruby
client.paginated_results(params) { |page| puts page.contents }
```

The method may hide away some complexity in retrieving pages.

```ruby
def paginated_results(params = {})
  before  = nil
  max     = 1000
  limit   = 50
  results = []

  loop do
    page = fetch_page(params.merge(before: before, limit: limit)) # imaginary request

    results += page

    yield page

    break if results.length >= max

    before = page.last["id"]
  end
end
```

To callers of this method, there is an implicit data structure. Being Ruby, we may expect to be able to call `Enumerable` methods on this data to inspect, slice, or augment the contents in a convenient way.

But we may not have access to method's internals and the underlying data structure, especially if we're using a method from an external library. This is the case with our `paginated_results` example; the `results` array is not exposed to the method caller.

Callers of the method are forced to build up state from the outside. Here's a contrived example:

```ruby
table_of_contents = []
index = 0

client.paginated_results(order: :asc) do |p|
  table_of_contents << [index+1, p.title] if p.title_page?
end

puts table_of_contents
```

There's another way in Ruby! We can "enumeratorize" it!

Ruby's `to_enum` method is defined on all objects. Quite simply, it can convert a method into `Enumerator`:

```ruby
client.to_enum(:paginated_results, params)
# => <Enumerator ...>
```

What this gives us is an enumerable object that behaves as if we built up that array ourselves, which means we can call methods from the `Enumerable` module, chain other enumerators to augment the block arguments, use `lazy`, etc.

```ruby
client.to_enum(:paginated_results, params).
  filter(:title_page?).
  map.with_index { |p, i| [i+i, p.title] }
```

I love this type of expression because it's more direct, flexible, and intention revealing. Authors need be less concerned with building up state with local variables.

In fact, this pattern is so useful that many authors have started building in `to_enum` to such methods for when the caller omits the block. The implementation for `paginated_results` might look like this:

```ruby
def paginated_results(params = {})
  return to_enum(__method__, params) unless block_given?

  # rest unchanged
end
```

While you are free to stick with the imperative approach, I hope this post demonstrates how `to_enum` offers Rubyists a more declarative and functionally-flavored alternative.

### Wrapping up

When you're in a punch, you can use `to_enum` to wrap iterative methods to add otherwise missing `Enumerable` properties. And, when designing your classes, consider adopting the `return to_enum(__method__) unless block_given?` pattern in method definitions to enhance iterative methods.
