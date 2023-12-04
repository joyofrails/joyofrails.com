---
title: How to specify local Ruby gems in your Gemfile
author: Ross Kaffenberger
published: 2023-09-01
summary: Stop adding :path in your Gemfile and use bundle config instead
description: Use the "bundle config" command to develop against local Ruby gems instead of following the typical advice to specify the :path option in your Gemfile.
thumbnail: 'blog/stock/jellyfish-pexels-photo.jpeg'

category: Code
tags:
  - Ruby
---

Let's say you're building a Ruby app and your team has extracted one or more
gems referenced in your Gemfile, such as your custom Trello API client, [Tacokit.rb](https://github.com/rossta/tacokit.rb).

```ruby
# Gemfile
source "https://rubygems.org"

# lots of gems ...

gem "tacokit"
```

Maybe Trello made some recent changes to their API that your current feature depends
on, so you need to update the `Tacokit` gem as part of your work. You have a
local checkout of the `tacokit` gem in another directory in your laptop.

You add some code to the gem, but now you want to test the changes in your app. How do you do that?

According to _[the most popular answer (and accepted) answer](http://stackoverflow.com/questions/4487948/how-can-i-specify-a-local-gem-in-my-gemfile#answer-4488110)_ to the question, ["How can I specify a local gem in my Gemfile?"](http://stackoverflow.com/questions/4487948/how-can-i-specify-a-local-gem-in-my-gemfile), we should do the following:

```ruby
gem "tacokit", path: "/path/to/tacokit"
```

Here's my take: **avoid this recommendation**

...especially if you work on a team and/or deploy this code to remote servers.

## WAT

Technically, it does work. Run `$ bundle update`, restart the app, and - boom! - our changes in
the local `tacokit` checkout are showing up as expected.

Then the trouble begins.

We push our app changes and deploy to the staging server to test them out
in the shared environment and - wait a minute - the app won't even start.

```sh
$ bundle
The path `/Users/ross/does/not/exist` does not exist.
```

Oops! We forgot to remove the `:path` reference in the `Gemfile`.

Let's fix that... we remove the `:path` reference, push, and redeploy. The app
restarts fine. But while testing the feature, we start getting 500 errors. This wasn't happening locally.

> "But it worked on my machine!" - _every developer ever_

The Rails logs reveal we have a bunch of undefined method errors coming from calls to `Tacokit`. That's right, we forgot another key step in this workflow: pushing our local `Tacokit` changes to the remote!

OK, after we've done that and redeployed the app, we're still getting 500 errors.

D'oh! We were working on a _branch_ of `tacokit` but we reference it in our app's `Gemfile`.

## Taking a step back

Good thing we weren't pushing that app feature to production. We would have been wise to run the tests on our CI server first where we would have seen the same errors (assuming we had the right tests... and a CI server).

Using the `:path` often means pointing to a location that only exists on our local machine. Every time we want to develop against the local `tacokit` gem, we have to remember to edit the `Gemfile` to remove the option so we don't screw up our teammates or break the build. We also can't forget to point to correct branch.

This workflow is no good because we're human and humans tend to forget to do things.

## "bundle config local" to the rescue

Buried deep in the Bundler docs is a better solution for [working with local git repo](http://bundler.io/git.html#local): the `bundle config local` command. Instead of specifying the `:path` option, we can run the following on command line:

```sh
$ bundle config local.tacokit /path/to/tacokit
```

Here we instruct Bundler to look in a local resource by modifying our local Bundler configuration. That's the one that lives in
`.bundle/config` outside of version control.

**No more editing shared code for local development settings.**

We can confirm the link with `bundle config`:

```sh
$ bundle config
Settings are listed in order of priority. The top value will be used.
local.tacokit
Set for your local app (/Users/rossta/.bundle/config): "/Users/rossta/path/to/tacokit"
```

We can scope the configuration to a specific folder with the `--local` flag:

```sh
$ bundle config --local local.tacokit /path/to/tacokit
$ bundle config
Settings are listed in order of priority. The top value will be used.
local.tacokit
Set for your local app (/Users/rossta/path/to/app/.bundle/config): "/Users/rossta/path/to/tacokit"
```

To take advantage of this local override in the app, we have to specify the remote repo and branch in the `Gemfile`:

```ruby
gem "tacokit", github: "rossta/tacokit", branch: "master"
```

Bundler will abort if the local gem branch doesn't match the one in the `Gemfile` and checks that the sha in Gemfile.lock exists in the local repository.

**This way we ensure our Gemfile.lock contains a valid reference to our local gem.**

We don't get these assertions when using the `:path` option.

It's easy to remove the local config after we don't need it:

`bundle config --delete local.YOUR_GEM_NAME`

## Caveats

As with the `:path` option, we still need to remember to push our
local gem changes to the remote repository when using `bundle config local`.

I should also mention that a good use case for using `:path` instead of `bundle
config local` it when the local gem is in a subdirectory relative to your app,
like when using [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
I don't often see this in practice, but there are valid reasons for doing so.
The main point here is that the Gemfile options work for all systems where the
repository is bundled.

In general, I'd encourage using either approach sparingly for gems that your
team doesn't own as it's typically best to stick the official releases for
active repositories. In my experience, it's most common to develop against local gems for
projects that your team _does_ own, so `bundle config local` will ensure your
co-workers know where to look to verify code dependencies.

## Don't use :path, use bundle config local instead

Though convenient, using the `:path` option in our `Gemfile` to point to a local
gem elsewhere on our machine sets us up for three potential problems without automated prevention:

- Committing a nonexistent lookup path on other machines
- Failing to point to the correct repository branch
- Failing to point to an existing git reference

Forget the `:path` option and you'll never forget ^^this stuff^^ again.

Just use this command:

```sh
bundle config local.YOUR_GEM_NAME
```

And don't believe everything you read on StackOverflow.
