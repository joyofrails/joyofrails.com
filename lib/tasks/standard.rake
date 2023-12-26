begin
  require "standard/rake"
rescue LoadError
  task :standard do
    warn "standard is not available. Skipping standard rake task."
  end
end
