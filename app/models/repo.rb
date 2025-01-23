# We take advantage of the fact that our deployment tool is Hatchbox which uses
# git on the server as part of the deploy process. We abstract git commands so callers
# don’t need to be aware of the fact that the git repository is in a different location.
class Repo
  def root = ENV.fetch("REPOSITORY_ROOT", ".")

  def read_file(path, revision: "HEAD")
    run "git show #{revision}:#{path}"
  end

  def rev_parse(revision = "HEAD")
    run("git rev-parse #{revision}").strip
  end

  def url(path = "")
    path = path.drop(1) if path.start_with?("/")
    "https://github.com/joyofrails/joyofrails.com/#{path}"
  end

  def run(command)
    `(cd #{root} && #{command}) 2>/dev/null`
  end
end
