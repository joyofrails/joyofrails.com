module LitestreamExtensions
  module Setup
    module_function

    def configure_litestream
      if litestream_bucket.blank?
        Rails.logger.debug "[#{self}] Skipping Litestream configuration"
        return
      end
      File.write(config_path, YAML.dump(litestream_config))

      # Here’s the command needed to check the status of the Litestream service on Hatchbox:
      Litestream.systemctl_command = "systemctl --user status joyofrails-litestream.service"
    end

    def config_path
      Rails.env.production? ? Rails.root.join("config", "litestream.yml") : Rails.root.join("config", "litestream", "#{Rails.env}.yml")
    end

    def litestream_config
      {
        "dbs" => database_paths.map do |database_path|
          {
            "path" => "./#{database_path}",
            "replicas" => [
              {
                "url" => "s3://#{litestream_bucket}/#{database_path}",
                "access-key-id" => Rails.application.credentials.litestream&.access_key_id,
                "secret-access-key" => Rails.application.credentials.litestream&.secret_access_key
              }
            ]
          }
        end
      }
    end

    def database_paths
      ActiveRecord::Base
        .configurations
        .configs_for(env_name: Rails.env, include_hidden: true)
        .filter_map { |config| (config.adapter == "sqlite3") ? config.database : nil }
    end

    def litestream_bucket
      Rails.application.credentials.litestream&.bucket
    end
  end
end
