begin
  require "reek/rake/task"

  Reek::Rake::Task.new do |t|
    t.fail_on_error = false
  end
rescue LoadError
  namespace :reek do
    desc "Run Reek"
    task :run do
      warn "reek is not available. Skipping reek:run task."
    end
  end
end
