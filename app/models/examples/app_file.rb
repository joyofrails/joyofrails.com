# frozen_string_literal: true

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
      return disk_read if @revision == "HEAD" # Don’t cache HEAD

      Rails.cache.fetch([:app_file, @revision, @path]) { git_read }
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

    private

    def disk_read
      git_read.presence || file_read
    end

    def file_read
      File.read(@path)
    end

    def git_read
      git_dir = ENV.fetch("REPOSITORY_ROOT", ".")
      `(cd #{git_dir} && git show #{@revision}:#{@path}) 2>/dev/null`
    end
  end
end
