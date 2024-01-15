require "litestream"

module LitestreamExtensions
  module Commands
    module_function

    # Using this in place of Litestream::Commands.replicate to customize configuration path
    def replicate
      if Litestream.configuration
        ENV["LITESTREAM_DATABASE_PATH"] = Litestream.configuration.database_path
        ENV["LITESTREAM_REPLICA_URL"] = Litestream.configuration.replica_url
        ENV["LITESTREAM_ACCESS_KEY_ID"] = Litestream.configuration.replica_key_id
        ENV["LITESTREAM_SECRET_ACCESS_KEY"] = Litestream.configuration.replica_access_key
      end

      system(Litestream::Commands.executable, "replicate", "--config", config_path.to_s)
    end

    def config_path
      LitestreamExtensions::Setup.config_path
    end
  end
end
