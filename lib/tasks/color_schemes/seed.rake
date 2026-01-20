namespace :color_schemes do
  desc "Seed color schemes from JSON files"
  task seed: :environment do
    ColorSchemes::Seed.new.seed_all
  end

  task :generate_1500 do
    `node ./script/colors/generate-1500-hex.js > ./script/colors/tmp/1500-palette-hex.json`
  end
end
