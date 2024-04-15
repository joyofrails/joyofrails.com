module Wasm
  class UploadWasmJob < ApplicationJob
    queue_as :default

    def perform(*args)
      cloud_api = CloudStorage::Api.new(Wasm.s3_bucket_name)
      base_path = Wasm.s3_base_path

      Dir.glob(".wasm/*.br").each do |local_file|
        file = File.basename(local_file).gsub(".br", "")
        s3_key = "#{base_path}/#{file}"
        exists_result = cloud_api.exists?(s3_key)
        Rails.logger.info "[#{self.class}] s3_object head for key #{s3_key}: #{exists_result.data.inspect}"

        if exists_result.data.present?
          Rails.logger.info "[#{self.class}] File upload already exists: #{s3_key}"
        else
          raise "File not found: #{local_file}" if !File.exist?(local_file)

          Rails.logger.info "[#{self.class}] File uploading #{s3_key.inspect} #{local_file.inspect}"
          result = cloud_api.upload(
            :key => s3_key,
            :body => File.open(local_file, "rb"),
            :public => true,
            "Cache-Control" => "max-age=31536000",
            "Content-Type" => "application/wasm",
            "Content-Encoding" => "br"
          )

          Rails.logger.info "[#{self.class}] File upload result #{local_file.inspect}\n#{result.inspect}"
        end
      end
    end
  end
end
