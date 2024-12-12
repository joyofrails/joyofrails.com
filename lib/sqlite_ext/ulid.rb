require "sqlite_ulid"

module SqliteExt
  module Ulid
    def self.to_path
      SqliteUlid.ulid_loadable_path
    end
  end
end
