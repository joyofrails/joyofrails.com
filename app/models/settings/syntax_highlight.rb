class Settings::SyntaxHighlight
  include ActiveModel::Model

  class << self
    def default
      find("dracula")
    end

    def find(name)
      attrs = curated_data.find { |attrs| attrs[:name] == name }
      if attrs.present?
        new(**attrs)
      else
        raise ActiveRecord::RecordNotFound, "Couldn't find SyntaxHighlight with name '#{name}'"
      end
    end

    def curated
      curated_data.map { |attrs| new(**attrs) }
    end

    def curated_data
      @curated_data ||= YAML.load_file(Rails.root.join("config", "syntax_highlights.yml"))
    end
  end

  attr_accessor :name, :mode

  def initialize(name:, mode:, **)
    @name = name
    @mode = mode
  end

  def display_name
    name.titleize
  end

  def ==(other)
    return false if other.nil? || !other.is_a?(self.class)

    name == other.name && mode == other.mode
  end

  def path
    Rails.root.join("app", "assets", "stylesheets", "pygments", "#{name}.css")
  end

  def asset_path
    "pygments/#{name}.css"
  end
end
