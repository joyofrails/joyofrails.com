module Examples
  class AppFile
    class << self
      def glob(pattern)
        Dir[pattern].map { |path| new(path) }
      end
      alias_method :[], :glob

      def find(path)
        raise ActiveRecord::RecordNotFound unless File.exist?(path)

        new(path)
      end

      def from(path, **)
        case path
        when AppFile, File
          new(path.path, **)
        when String, Pathname
          new(path, **)
        else
          raise ArgumentError, "Invalid AppFile path: #{path.inspect}"
        end
      end
    end

    attr_reader :path, :revision
    alias_method :filename, :path

    def initialize(path, revision: "HEAD")
      @path = path
      @revision = revision
    end

    def readlines
      read.scan(%r{.*\n})
    end

    def read
      Dir.chdir(ENV.fetch("REPOSITORY_ROOT", ".")) do
        `git show #{@revision}:#{@path}`.strip
      end
    end
    alias_method :content, :read

    def app_path
      @path.sub(Rails.root.to_s + "/", "")
    end

    def basename(*)
      File.basename(@path, *)
    end

    def extname
      File.extname(@path)
    end
    alias_method :extension, :extname

    def repo_url
      "https://github.com/joyofrails/joyofrails.com/blob/#{revision}/#{app_path}"
    end

    def source(lines: nil)
      lines = Array(lines)

      content = if lines.present?
        lines = lines.map { |e| [*e] }.flatten.map(&:to_i).map { |e| e - 1 }

        readlines.values_at(*lines).join
      else
        read
      end

      content.strip.html_safe
    end
  end
end
