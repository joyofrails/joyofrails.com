class Snippet < ApplicationRecord
  validates :language, presence: true

  validate :recognized_language
  before_validation :auto_detect_language, if: :auto_detecting?

  attr_reader :auto_detecting

  def language=(value)
    if value == "auto"
      @auto_detecting = true
      super(guess_language)
    else
      super(value.to_s.downcase)
    end
  end

  def auto_detect_language
    self.language = guess_language
  end

  def guess_language
    Rouge::Lexer.guesses({filename: filename, source: source}.compact).first&.tag
  end

  private

  def auto_detecting? = !!@auto_detecting

  def recognized_language
    return if Rouge::Lexer.find(language)

    message = auto_detecting? ? "could not be auto-detected from filename or source" : "is not a recognized language"
    errors.add(:language, message)
  end
end
