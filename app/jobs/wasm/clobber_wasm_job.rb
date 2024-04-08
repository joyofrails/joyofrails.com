module Wasm
  class ClobberWasmJob < ApplicationJob
    queue_as :default

    def perform(*args)
      Rails.logger.info "[#{self.class}] Deleting files in s3://#{Wasm.s3_bucket_name}/#{Wasm.s3_base_path}"

      cloud_api = CloudStorage::Api.new(Wasm.s3_bucket_name)
      cloud_api.delete_all(Wasm.s3_base_path)
    end
  end
end
