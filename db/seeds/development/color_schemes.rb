ColorScheme.find_or_create_default

hex_json_uicolors = JSON.parse(File.read("./script/colors/data/uicolors-palette-hex.json"))
ColorScheme.bulk_load(hex_json_uicolors) { |name| "Custom #{name.titleize}" }
Rails.cache.delete("curated_color_scheme_options")
