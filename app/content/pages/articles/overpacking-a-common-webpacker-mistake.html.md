---
title: 'Overpacking: A common Webpacker mistake'
author: Ross Kaffenberger
published: 2019-12-03
summary: i.e., How I saved 6 minutes in a Rails team's deploy time
description: A big issue that comes up with Webpacker is "where to put the JavaScript files". This post demonstrates proper use of entry point files, called packs, with Webpacker and Rails and will help developers avoid a common gotcha.
thumbnail: 'blog/stock/brandless-packing-unsplash.jpg'
thumbnail_caption: Photo by Brandless on Unsplash
series:
category: Code
layout: article
tags:
  - Webpack
  - Rails
type: WTF
---

I recently encountered a Rails app at work that was spending nearly seven minutes precompiling assets:

```ruby:app/controllers/posts_controller.rb
# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.

class ApplicationMarkdown < MarkdownRails::Renderer::Rails
  # Reformats your boring punctation like " and " into “ and ” so you can look
  # and feel smarter. Read the docs at https://github.com/vmg/redcarpet#also-now-our-pants-are-much-smarter
  include Redcarpet::Render::SmartyPants

  # If you need access to ActionController::Base.helpers, you can delegate by uncommenting
  # and adding to the list below. Several are already included for you in the `MarkdownRails::Renderer::Rails`,
  # but you can add more here.
  #
  delegate \
    :link_to,
    :inline_svg,
    to: :helpers

  def extensions
    [
      :autolink,
      :disable_indented_code_blocks,
      :fenced_code_blocks,
      :no_intra_emphasis,
      :smartypants
    ].map { |feature| [feature, true] }.to_h
  end

  def options
    {
      with_toc_data: true
    }
  end

  def renderer
    ::Redcarpet::Markdown.new(self.class.new(options), **extensions)
  end

  def link(url, title, text)
    custom_link_to(url, text)
  end

  def autolink(url, link_type)
    custom_link_to(url, url)
  end

  def header(text, header_level)
    content_tag :div, id: text.parameterize, class: "anchor group" do
      content_tag "h#{header_level}", class: "flex items-center" do
        anchor_tag(text, class: ["anchor-link not-prose"]) + text
      end
    end
  end

  def block_code(code, metadata)
    language, filename = metadata.split(":") if metadata

    lexer = Rouge::Lexer.find(language)

    tag.pre(class: "highlight language-#{language}") do
      tag.div(class: "code-header") do
        html = inline_svg("app-dots.svg", class: "app-dots")
        if filename
          html += tag.span(filename, class: "code-filename")
        end
        html
      end + tag.code do
        raw code_formatter.format(lexer.lex(code))
      end
    end
  end

  def image(link, title, alt_text)
    url = URI(link)
    case url.host
    when "www.youtube.com"
      youtube_tag url, alt_text
    else
      image_tag(link, title: title, alt: alt_text, loading: "lazy")
    end
  end

  private

  def code_formatter
    @code_formatter ||= Rouge::Formatters::HTML.new
  end

  # This is provided as an example; there's many more YouTube URLs that this wouldn't catch.
  def youtube_tag(url, alt)
    embed_url = "https://www.youtube-nocookie.com/embed/#{CGI.parse(url.query).fetch("v").first}"
    content_tag :iframe,
      src: embed_url,
      width: 560,
      height: 325,
      allow: "encrypted-media; picture-in-picture",
      allowfullscreen: true \
    do
      alt
    end
  end

  def custom_link_to(url, text)
    attributes = {}

    unless url.blank? || url.start_with?("/", "#")
      attributes[:target] = "_blank"
      attributes[:rel] = "noopener noreferrer"
    end

    link_to(raw(text), url, attributes)
  end

  def anchor_tag(text, **)
    link_to("##{text.parameterize}", **) do
      raw(anchor_svg) + content_tag(:span, "Link to heading", class: "sr-only")
    end
  end

  def anchor_svg
    <<-SVG
      <svg version="1.1" aria-hidden="true" stroke="currentColor" viewBox="0 0 16 16" width="28" height="28">
        <path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path>
      </svg>
    SVG
  end
end
```

I looked in the `Gemfile` and found the project was using Webpacker. My spidey sense started to tingle.

[Here's an article on my site](/joyofrails) no target blank

_I've seen this before_.

Leaning on prior experience, I found the problem, moved some files around, and pushed a branch with the fix up to CI.

The build step dropped from nearly seven minutes to less than one. Big improvement! When I heard from the team, the fix also greatly improved the local development experience; before, re-compiling webpack assets on page refreshes would take a painfully long time.

So what were the changes?

> [Subscribe to my newsletter](https://buttondown.email/joyofrails), Joy of Rails, to get notified about new content.

### A Common Problem

First, let's take a step back. If you're new to webpack and Webpacker for Rails, chances are you may be making some simple mistakes.

I know this because I was once in your shoes struggling to learn how webpack works. I've also spent a lot of time helping others on my team, on StackOverflow, and via [`rails/webpacker`](https://github.com/rails/webpacker) Github issues.

One of the most frequently-reported issues I've seen is slow build times. This is often coupled with high memory and CPU usage. For Heroku users on small dynos, resource-intensive asset precompilation can lead to failed deploys.

More often than not, the root cause is a simple oversight in directory structure—a mistake I call "overpacking".

### Overpacking explained

Here's the layout of the `app/javascript` directory in the Rails app _before_ I introduced the fix:

**rake assets:precompile — 6:56**

```shell
app/
  javascript/
    packs/
      application.js
      components/     # lots of files
      images/         # lots of files
      stylesheets/    # lots of files
      ...
```

Here's what the project looked like building in under a minute:

**rake assets:precompile — 0:44**

```shell
app/
  javascript/
    components/
    images/
    stylesheets/
    ...
    packs/
      application.js    # just one file in packs/
```

See the difference?

The primary change here was moving everything except `application.js` outside of the `packs` directory under `app/javascript`. (To make this work properly, I also had to update some relative paths in `import` statements.)

### Webpack Entry Points

So why did this matter?

Webpack needs at least one **entry** point to build the dependency graph for produce the JavaScript and CSS bundles and static assets (images, fonts, etc).

> The Webpacker project refers to entries as **packs**.

"Entry" is listed as the first key concept on webpack's documentation site: https://webpack.js.org/concepts/#entry.

Webpack will build a separate dependency graph for every entry specified in its configuration. The more entry points you provide, the more dependency graphs webpack has to build.

Since webpack*er*, by default, treats _every file_ in the `packs` directory as a separate entry, it will build a separate dependency graph for _every file_ located there.

That also means, for _every file_ in the `packs` directory, there will be at least one, possibly more, files emitted as output in the `public` directory during precompilation. If you're not linking to these files anywhere in your app, then they don't need to be emitted as output. For a large project, that could be lot of unnecessary work.

Here's a case where Rails tries to make things easier for you—by auto-configuring entry files—while also making it easier to shoot yourself in the foot.

### A Simple Rule

Is your Webpacker compilation taking forever? You may be overpacking.

> If any file in Webpacker's "packs" directory does not also have a corresponding `javascript_pack_tag` in your application, then you're overpacking.

Be good to yourself and your development and deployment experience by being very intentional about what files you put in your "packs" directory.

Don't overpack. At best, this is wasteful; at worst, this is a productivity killer.
