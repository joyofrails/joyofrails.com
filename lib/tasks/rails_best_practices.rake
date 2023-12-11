namespace :rails_best_practices do
  desc "Run rails best practices"
  task :run do
    puts "Running rails best practices!"
    puts `rails_best_practices`
  end
end
