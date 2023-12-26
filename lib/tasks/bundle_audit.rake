begin
  require "bundler/audit/task"
  Bundler::Audit::Task.new
rescue LoadError
  namespace :bundle do
    desc "Audit gems for CVEs"
    task :audit do
      warn "bundler-audit is not available. Skipping bundle:audit task."
    end
  end
end
