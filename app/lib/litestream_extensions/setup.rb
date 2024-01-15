module LitestreamExtensions
  module Setup
    LITESTACK_DATABASES_FOR_LITESTREAM = %w[data metrics queue]

    module_function

    def configure_litestream
      File.write(Rails.root.join("config", "litestream.yml"), YAML.dump(litestream_config))
    end

    def litestream_config
      {
        "dbs" => LITESTACK_DATABASES_FOR_LITESTREAM.map do |db|
          {
            "path" => File.join(litestack_data_path, Rails.env, "#{db}.sqlite3"),
            "replicas" => [{"url" => "s3://#{litestream_bucket}/#{Rails.env}/#{db}.sqlite3"}]
          }
        end
      }
    end

    def litestack_data_path
      ENV.fetch("LITESTACK_DATA_PATH", "./storage")
    end

    def litestream_bucket
      Rails.application.credentials.litestream.bucket
    end
  end
end
