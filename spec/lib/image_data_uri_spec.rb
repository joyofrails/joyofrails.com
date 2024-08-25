require "spec_helper"
require_relative "../../lib/image_data_uri"

RSpec.describe ImageDataUri do
  let(:png_data_uri) { "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==" }
  let(:jpeg_data_uri) { "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAABAAEDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3+iiigD//2Q==" }

  describe "#initialize" do
    it "parses a valid PNG data URI" do
      image_uri = ImageDataUri.new(png_data_uri)
      expect(image_uri.content_type).to eq("image/png")
      expect(image_uri.encoding).to eq("base64")
    end

    it "parses a valid JPEG data URI" do
      image_uri = ImageDataUri.new(jpeg_data_uri)
      expect(image_uri.content_type).to eq("image/jpeg")
      expect(image_uri.encoding).to eq("base64")
    end

    it "raises an error for invalid data URI format" do
      expect { ImageDataUri.new("invalid_uri") }.to raise_error(ArgumentError, "Invalid data URI format")
    end

    it "raises an error for unsupported encoding" do
      expect { ImageDataUri.new("data:image/png;base32,ABCDEF") }.to raise_error(ArgumentError, "Unsupported encoding")
    end
  end

  describe "#to_file" do
    let(:image_uri) { ImageDataUri.new(png_data_uri) }

    before do
      allow(File).to receive(:binwrite)
    end

    it "writes the file data to the specified path" do
      path = "test_image"
      expect(File).to receive(:binwrite).with("#{path}.png", kind_of(String))
      image_uri.to_file(path)
    end

    it "appends the correct extension when not provided" do
      expect(image_uri.to_file("image")).to eq("image.png")
    end

    it "does not modify the path when extension is provided" do
      expect(image_uri.to_file("image.png")).to eq("image.png")
    end

    it "uses .bin extension for unknown mime types" do
      unknown_data_uri = "data:image/unknown;base64,ABCDEF"
      image_uri = ImageDataUri.new(unknown_data_uri)
      expect(image_uri.to_file("image")).to eq("image.bin")
    end
  end

  describe "#to_file_data" do
    it "returns decoded file data" do
      image_uri = ImageDataURI.new(png_data_uri)
      expect(image_uri.to_file_data).to be_a(String)
      expect(image_uri.to_file_data.bytesize).to be > 0
    end
  end
end
