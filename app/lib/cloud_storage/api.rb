module CloudStorage
  class Api
    Result = Struct.new(:data, :error, keyword_init: true) do
      def success?
        error.nil?
      end
    end

    attr_reader :bucket_name

    def initialize(bucket_name)
      @bucket_name = bucket_name
    end

    def exists?(cloud_path)
      data = bucket.files.head(cloud_path)
      Result.new(data: data)
    end

    def files(cloud_path)
      s3.directories.get(@bucket_name, prefix: cloud_path).files
    end

    def upload(options = {})
      data = bucket.files.create(options)
      Result.new(data: data)
    end

    def delete_all(cloud_path)
      data = files(cloud_path).map(&:destroy)

      Result.new(data: data)
    end

    def bucket
      @bucket ||= s3.directories.get(@bucket_name)
    end

    def s3
      @s3 ||= begin
        require "fog/aws"
        Fog::AWS::Storage.new(
          aws_access_key_id: Rails.application.credentials.wasm.aws.access_key_id,
          aws_secret_access_key: Rails.application.credentials.wasm.aws.secret_access_key
        )
      end
    end

    private
  end
end
