require_relative "../../lib/sqlpkg_loader"

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  prepend SqlpkgLoader
end

# Legacy
require_relative "../../lib/enhanced_sqlite3"

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  prepend EnhancedSqlite3::Adapter
end
