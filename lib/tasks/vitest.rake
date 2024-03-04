namespace :vitest do
  desc "Run vitest tests in watch mode"
  task :watch do |task, args|
    require "open3"
    puts "Running Vitest tests!"

    sh("bin/vitest") or raise "Vitest tests failed!"
  end

  desc "Run vitest tests and exit"
  task :run do |task, args|
    require "open3"
    puts "Running Vitest tests!"

    sh("bin/vitest --watch=false") or raise "Vitest tests failed!"
  end
end

task vitest: "vitest:watch"
