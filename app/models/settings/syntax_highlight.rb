class Settings::SyntaxHighlight
  include ActiveModel::Model

  class << self
    def default
      find("dracula")
    end

    def find(name)
      if available_names.include?(name)
        new(name: name)
      else
        raise ActiveRecord::RecordNotFound, "Couldn't find SyntaxHighlight with name '#{name}'"
      end
    end

    def curated
      available_names.map { |name| find(name) }
    end

    def available_names
      @available_names ||= Dir.glob(css_glob_pattern).map { |file| File.basename(file, ".css") }
    end

    private

    def css_glob_pattern
      Rails.root.join("app", "assets", "stylesheets", "pygments", "*.css")
    end
  end

  attr_accessor :name

  def initialize(name:)
    @name = name
  end

  def ==(other)
    return false if other.nil? || !other.is_a?(self.class)

    name == other.name
  end

  def path
    Rails.root.join("app", "assets", "stylesheets", "pygments", "#{name}.css")
  end

  def asset_path
    "pygments/#{name}.css"
  end
end
