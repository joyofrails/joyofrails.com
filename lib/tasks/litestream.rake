namespace :litestream do
  desc "Replicate SQLite databases"
  task custom_replicate: :environment do
    LitestreamExtensions::Commands.replicate
  end
end
