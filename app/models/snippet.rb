require_relative "../../lib/image_data_uri"
class Snippet < ApplicationRecord
  validates :language, presence: true

  validate :recognized_language
  before_validation :auto_detect_language, if: :auto_detecting?

  has_one_attached :screenshot

  belongs_to :author, polymorphic: true, inverse_of: :snippets

  attr_reader :auto_detecting

  def attach_screenshot_from_base64(data)
    data_uri = ImageDataUri.new(data)
    image_filename = filename.presence || SecureRandom.uuid
    image_filename = [image_filename.parameterize, data_uri.extension].join

    screenshot.attach(
      io: StringIO.new(data_uri.file_data),
      content_type: data_uri.content_type,
      filename: image_filename
    )
  end

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
