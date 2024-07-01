namespace :color_scales do
  desc "Seed ColorScales from JSON files"
  task seed: :environment do
    # Generate ColorScale rows from precalcated JSON
    # "hex json" files are expected to represent JSON objects of color scales: { name: { weight: color, ... }, ...

    if !File.exist?("./script/colors/tmp/1500-palette-hex.json")
      puts "Run `rake color_scales:generate_1500` first to generate 1500-palette-hex.json"
      exit
    end

    hex_json_1500 = JSON.parse(File.read("./script/colors/tmp/1500-palette-hex.json"))
    hex_json_1500.each do |name, weights|
      ColorScale.find_or_create_by!(name: name) do |cs|
        weights.each do |weight, css|
          cs.set_weight(weight, css)
        end
      end
    end

    hex_json_uicolors = JSON.parse(File.read("./script/colors/data/uicolors-palette-hex.json"))
    hex_json_uicolors.each do |name, weights|
      custom_name = "Custom #{name.titleize}"
      ColorScale.find_or_create_by!(name: custom_name) do |cs|
        weights.each do |weight, css|
          cs.set_weight(weight, css)
        end
      end
    end
  end

  task :generate_1500 do
    `node ./script/colors/generate-1500-hex.js > ./script/colors/tmp/1500-palette-hex.json`
  end
end
