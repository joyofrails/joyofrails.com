namespace :development do
  desc "Prune branch-specific databases"
  task :prune_data do
    Dir["storage/development/data-*.sqlite3"]
      .each { |file| File.delete(file) && puts("Deleted #{file}") }
  end
end
