# Contributing

Thank you for interest in contributing to Joy of Rails. Please take a moment to review this document before submitting a pull request.

Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open source project. In return, they should reciprocate that respect in addressing your issue, assessing changes, and helping you finalize your pull requests.

Joy of Rails is an open source project and we love to receive contributions from our community — you! There are many ways to contribute, from improving the documentation, fixing typos, submitting bug reports and feature requests or writing code which can be incorporated into the application itself.

## Pull requests

**Please ask first before starting work on any significant new features.**

It's never a fun experience to have your pull request declined after investing a lot of time and effort into a new feature. To avoid this from happening, we request that contributors create [a feature request](https://github.com/joyofrails/joyofrails.com/discussions/new?category=ideas) to first discuss any new ideas. Your ideas and suggestions are welcome!

Please ensure that the tests are passing when submitting a pull request. If you're adding new features, please include tests.

Working on your first pull request? You can learn how from these friendly tutorials:

- https://makeapullrequest.com/
- https://www.firsttimersonly.com/
- https://egghead.io/courses/how-to-contribute-to-an-open-source-project-on-github

## Where do I go from here?

For any questions, support, or ideas, etc. [please create a GitHub discussion](https://github.com/joyofrails/joyofrails.com/discussions/new). If you've noticed a bug, [please submit an issue][new issue].

### Fork and create a branch

If this is something you think you can fix, then [fork Joy of Rails](https://github.com/joyofrails/joyofrails.com/fork) and create a branch with a descriptive name.

### Get the test suite running

Make sure you're using the correct [Ruby version](.ruby-version) and [Node version](.nvmrc).

Run the installation script to get the application set up:

```sh
bin/setup
```

Now you should be able to run the entire suite using:

```sh
bin/verify
```

### Implement your fix or feature

At this point, you're ready to make your changes. Feel free to ask for help.

### View your changes in a Rails application

Make sure to take a look at your changes in a browser. To boot up the Rails development server and supporting processes:

```sh
bin/dev
```

You should now be able to open http://localhost:3000 in your browser.

If desired, open the Rails console with:

```sh
bin/rails console
```

To migrate the database for a new migration:

```sh
bin/rails db:migrate
```

### Create a Pull Request

At this point, if your changes look good and tests are passing, you are ready to create a pull request.

Github Actions will run our test suite.

## Merging a PR (maintainers only)

A PR can only be merged into the main branch by a maintainer if: CI is passing, approved by a maintainer, and is up to date with the default branch.
