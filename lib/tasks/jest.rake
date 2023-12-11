namespace :jest do
  desc "Run jest test"
  task :run do
    require "open3"
    puts "Running Jest tests!"

    sh("bin/jest") or raise "Jest tests failed!"
  end
end

task jest: "jest:run"
