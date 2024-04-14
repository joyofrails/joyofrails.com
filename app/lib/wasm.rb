# frozen_string_literal: true

module Wasm
  extend self

  S3_BUCKET_NAME = "rails-wasm"

  def app_version
    File.read("WASM_APP_VERSION").strip
  end

  def rails_version
    Rails.version.split(".").take(2).join(".")
  end

  def ruby_version
    RUBY_VERSION.split(".").take(2).join(".")
  end

  def s3_bucket_name
    S3_BUCKET_NAME
  end

  def s3_base_path
    "joyofrails/#{Rails.env.local? ? "#{Rails.env}/" : ""}#{app_version}"
  end
end
