class Settings::SyntaxHighlight
  include ActiveModel::Model

  def self.default
    find("dracula")
  end

  def self.find(name)
    instance = curated.find { |obj| obj.name == name }
    instance.presence or raise ActiveRecord::RecordNotFound, "Couldn't find SyntaxHighlight with name '#{name}'"
  end

  # This method lazily reifies and memoizes curated SyntaxHighlight instances. I may
  # want to consider a more sophisticated caching strategy.
  def self.curated
    @curated ||= curated_data.map { |attrs| new(**attrs) }
  end

  def self.all
    curated
  end

  def self.curated_data
    @curated_data ||= YAML.load_file(Rails.root.join("config", "syntax_highlights.yml"))
  end

  attr_accessor :name, :mode, :background_color

  def initialize(name:, mode:, background_color:, **)
    @name = name
    @mode = mode
    @background_color = background_color
  end

  def id = name

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
