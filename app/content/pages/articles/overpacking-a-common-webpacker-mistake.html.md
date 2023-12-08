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

I looked in the `Gemfile` and found the project was using Webpacker. My spidey sense started to tingle.

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
