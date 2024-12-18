require "sqlite_vec"

module SqliteExt
  module Vec
    def self.to_path = SqliteVec.loadable_path
  end
end
