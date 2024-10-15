namespace :color_schemes do
  desc "Seed color schemes from JSON files"
  task seed: :environment do
    # Generate ColorScheme rows from precalcated JSON
    # "hex json" files are expected to represent JSON objects of color scales: { name: { weight: color, ... }, ...

    if !File.exist?("./script/colors/tmp/1500-palette-hex.json")
      puts "Run `rake color_schemes:generate_1500` first to generate 1500-palette-hex.json"
      exit
    end

    hex_json_1500 = JSON.parse(File.read("./script/colors/tmp/1500-palette-hex.json"))
    ColorScheme.bulk_load(hex_json_1500)

    hex_json_uicolors = JSON.parse(File.read("./script/colors/data/uicolors-palette-hex.json"))
    ColorSchme.bulk_load(hex_json_uicolors) { |name| "Custom #{name.titleize}" }
  end

  task :generate_1500 do
    `node ./script/colors/generate-1500-hex.js > ./script/colors/tmp/1500-palette-hex.json`
  end
end
