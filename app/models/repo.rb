class Repo
  def root = ENV.fetch("REPOSITORY_ROOT", ".")

  def read_file(path, revision: "HEAD")
    run "git show #{revision}:#{path})"
  end

  def rev_parse(revision = "HEAD")
    run("git rev-parse #{revision}").strip
  end

  def url(path = "")
    Addressable::URI.join("https://github.com/joyofrails/joyofrails.com", path)
  end

  def run(command)
    `(cd #{root} && #{command}) 2>/dev/null`
  end
end
