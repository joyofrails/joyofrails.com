RepositoryCheck = Class.new(StandardError)
message = <<~MSG
  Repository check failed!

  The application cannot find the git repository at #{ENV.fetch("REPOSITORY_ROOT", ".")}
  Please set the REPOSITORY_ROOT environment variable to the path of the git repository.
MSG

Dir.chdir(ENV.fetch("REPOSITORY_ROOT", ".")) do
  if !system("git rev-parse")
    raise RepositoryCheck.new(message)
  end
end
