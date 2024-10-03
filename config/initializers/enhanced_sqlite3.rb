require_relative "../../lib/enhanced_sqlite3"

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  prepend EnhancedSqlite3::Adapter
end
