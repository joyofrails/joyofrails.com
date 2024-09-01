require "base64"
require "pathname"

class ImageDataUri
  attr_reader :content_type, :encoding, :data

  def initialize(data_uri)
    parse_data_uri(data_uri)
  end

  def to_file(path)
    path_with_extension = ensure_file_extension(path)
    File.binwrite(path_with_extension, file_data)
    path_with_extension
  end

  def file_data
    @file_data ||= Base64.decode64(@data)
  end

  def extension
    Rack::Mime::MIME_TYPES.invert[content_type]
  end

  private

  def parse_data_uri(data_uri)
    raise ArgumentError, "Invalid data URI format" unless data_uri.start_with?("data:")

    parts = data_uri.split(",", 2)
    raise ArgumentError, "Invalid data URI format" if parts.length != 2

    metadata, @data = parts
    metadata_parts = metadata.split(";")

    @content_type = metadata_parts[0].split(":")[1]
    @encoding = metadata_parts[1] if metadata_parts.length > 1

    raise ArgumentError, "Unsupported encoding" if @encoding && @encoding != "base64"
  end

  def ensure_file_extension(path)
    pathname = Pathname.new(path)
    return path if pathname.extname.size > 1

    extension = mime_to_extension(@content_type)
    "#{path}#{extension}"
  end

  def mime_to_extension(mime_type)
    {
      "image/jpeg" => ".jpg",
      "image/png" => ".png",
      "image/gif" => ".gif",
      "image/webp" => ".webp",
      "image/svg+xml" => ".svg"
    }.fetch(mime_type, ".bin")
  end
end
