require "fileutils"
require "rails/generators/testing/behavior"

# RSpec rails provides example groups for system tests, controller tests, model
# tests etc., each of which act as thin wrappers for Rails test case classes
# where possible. However, there is no built-in example group for generator
# tests.

module GeneratorExampleGrouple
  extend ActiveSupport::Concern
  include RSpec::Rails::RailsExampleGroup
  include Rails::Generators::Testing::Behavior
  include FileUtils

  def be_file(&)
    BeFile.new(destination_root, &)
  end

  # Leverage Rails::Generators::Testing::Behavior methods to set up sample Rails app in tmp directory
  included do
    tests described_class
    destination Rails.root.join("tmp", "spec", "generators")

    before do
      destination_root_is_set?
      ensure_current_path
      prepare_destination
    end

    after do
      ensure_current_path
    end
  end

  # Custom RSpec matcher to check for file existence and content
  #
  # @example
  #   expect("app/content/pages/articles/my-new-article.html.md").to be_file do |content|
  #     expect(content).to eq(expected_file_content)
  #   end
  class BeFile
    def initialize(destination_root, &block)
      @destination_root = destination_root
      @block = block
    end

    def description
      "be a file generated at #{relative}"
    end

    def matches?(relative)
      @relative = relative

      absolute = File.expand_path(relative, destination_root)
      return false if !File.exist?(absolute)

      yield File.read(absolute) if block_given?

      true
    end

    def failure_message
      "Expected file #{relative.inspect} to exist, but does not"
    end

    private

    attr_reader :destination_root, :relative, :block, :read
  end
end

RSpec.configure do |config|
  config.include GeneratorExampleGrouple, type: :generator
end
