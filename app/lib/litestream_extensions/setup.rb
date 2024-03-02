module LitestreamExtensions
  module Setup
    module_function

    def configure_litestream
      File.write(config_path, YAML.dump(litestream_config))
    end

    def databases
      ActiveRecord::Base
        .configurations
        .configs_for(env_name: Rails.env, include_hidden: true)
        .select { |config| ["sqlite3", "litedb"].include? config.adapter }
        .map(&:database)
    end

    def config_path
      Rails.root.join("config", "litestream.yml")
    end

    def litestream_config
      {
        "dbs" => databases.map do |db|
          {
            "path" => db,
            "replicas" => [{"url" => "s3://#{litestream_bucket}/#{db}"}]
          }
        end
      }
    end

    def litestream_bucket
      Rails.application.credentials.litestream.bucket
    end
  end
end
