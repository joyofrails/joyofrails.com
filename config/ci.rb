# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Style: ERB", "bin/erb_lint --lint-all"
  step "Style: Ruby", "bin/standardrb --parallel"

  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Tests: RSpec", "bin/rspec"
  step "Tests: Vitest", "npm run test"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  # if success?
  #   step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  # else
  #   failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  # end
end
