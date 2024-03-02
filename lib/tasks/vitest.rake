namespace :vitest do
  desc "Run vitest test"
  task :run do
    require "open3"
    puts "Running Vitest tests!"

    sh("bin/vitest") or raise "Vitest tests failed!"
  end
end

task vitest: "vitest:run"
