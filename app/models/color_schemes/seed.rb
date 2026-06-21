class ColorSchemes::Seed
  def seed_all
    seed_1500
    seed_ui
  end

  def seed_ui
    hex_json_uicolors = JSON.parse(File.read("./script/colors/data/uicolors-palette-hex.json"))
    hex_json_uicolors.each do |name, weights|
      custom_name = "Custom #{name.titleize}"
      ColorScheme.find_or_create_by!(name: custom_name) do |cs|
        weights.each do |weight, css|
          cs.set_weight(weight, css)
        end
      end
    end
  end

  def seed_1500
    # Generate ColorScheme rows from precalcated JSON
    # "hex json" files are expected to represent JSON objects of color scales: { name: { weight: color, ... }, ...

    if !File.exist?("./script/colors/tmp/1500-palette-hex.json")
      puts "Run `rake color_schemes:generate_1500` first to generate 1500-palette-hex.json"
      exit
    end

    hex_json_1500 = JSON.parse(File.read("./script/colors/tmp/1500-palette-hex.json"))
    hex_json_1500.each do |name, weights|
      ColorScheme.find_or_create_by!(name: name) do |cs|
        weights.each do |weight, css|
          cs.set_weight(weight, css)
        end
      end
    end
  end
end
