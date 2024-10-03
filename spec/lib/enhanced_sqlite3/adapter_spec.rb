require "rails_helper"

RSpec.describe EnhancedSqlite3::Adapter do
  it { expect(ActiveRecord::ConnectionAdapters::SQLite3Adapter).to be < described_class }
end
