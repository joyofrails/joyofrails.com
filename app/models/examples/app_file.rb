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
    end

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def read
      File.read(@path)
    end
    alias_method :content, :read
    alias_method :source, :read

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
  end
end
