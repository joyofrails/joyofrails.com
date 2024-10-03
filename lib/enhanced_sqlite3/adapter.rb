# frozen_string_literal: true

# Adapted from https://github.com/fractaledmind/activerecord-enhancedsqlite3-adapter
# https://github.com/fractaledmind/activerecord-enhancedsqlite3-adapter/blob/305795a2be47c66695ecda56d8df64ec9f92b880/lib/enhanced_sqlite3/adapter.rb

require "active_record/connection_adapters/sqlite3_adapter"

module EnhancedSqlite3
  module Adapter
    # Perform any necessary initialization upon the newly-established
    # @raw_connection -- this is the place to modify the adapter's
    # connection settings, run queries to configure any application-global
    # "session" variables, etc.
    #
    # Implementations may assume this method will only be called while
    # holding @lock (or from #initialize).
    #
    # overrides https://github.com/rails/rails/blob/main/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L691
    def configure_connection
      super
      configure_extensions
    end

    # Patch the #transaction method to ensure that all transactions are sent to the writing role database connection pool.
    def transaction(...)
      ActiveRecord::Base.connected_to(role: ActiveRecord.writing_role, prevent_writes: false) do
        super
      end
    end

    # Patch the #log method to ensure that all log messages are tagged with the database connection name.
    def log(...)
      db_connection_name = ActiveRecord::Base.connection_db_config.name
      if Rails.logger.formatter.current_tags.include? db_connection_name
        super
      else
        Rails.logger.tagged(db_connection_name) { super }
      end
    end

    private

    def configure_extensions
      @raw_connection.enable_load_extension(true)
      @config.fetch(:extensions, []).each do |extension_name|
        if extension_name.include?("/")
          raise LoadError unless Dir.exist?(".sqlpkg/#{extension_name}")
          Dir.glob(".sqlpkg/#{extension_name}/*.{dll,so,dylib}") do |extension_path|
            @raw_connection.load_extension(extension_path)
          end
        else
          require extension_name
          extension_classname = extension_name.camelize
          extension_class = extension_classname.constantize
          extension_class.load(@raw_connection)
        end
      rescue LoadError
        Dir.glob(".sqlpkg/**/*.{dll,so,dylib}") do |extension_path|
          @raw_connection.load_extension(extension_path)
        end
        Rails.logger.error("Failed to find the SQLite extension gem: #{extension_name}. Skipping...")
      rescue NameError
        Rails.logger.error("Failed to find the SQLite extension class: #{extension_classname}. Skipping...")
      end
      @raw_connection.enable_load_extension(false)
    end
  end
end
