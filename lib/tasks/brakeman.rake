namespace :brakeman do
  desc "Run Brakeman"
  task :run, :output_files do |t, args|
    require "brakeman"

    files = args[:output_files].split(" ") if args[:output_files]
    options = {
      app_path: ".",
      output_files: files,
      print_report: true,
      summary: true,
      pager: false,
      skip_files: [
        "build/",
        "rubies/",
        ".wasm/",
        "node_modules/",
        "vendor/",
        "tmp/"
      ]
    }
    result = Brakeman.run options
    if result.filtered_warnings.any?
      puts "Brakeman warnings found. Aborting now..."
      exit Brakeman::Warnings_Found_Exit_Code
    elsif result.errors.any?
      puts "Brakeman errors found. Aborting now..."
      exit Brakeman::Errors_Found_Exit_Code
    end
  end
end
