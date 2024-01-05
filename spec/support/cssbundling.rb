require "rake"

RSpec.configure do |config|
  [:system, :request].each do |type|
    config.when_first_matching_example_defined(type: type) do
      @cssbundling_complete ||= false

      next if @cssbundling_complete

      command = "yarn build:css"
      puts "cssbundling-rails: Running `#{command}` to build CSS..."
      unless system(command)
        raise "cssbundling-rails: Command build failed, ensure `#{command}` runs without errors"
      end

      @cssbundling_complete = true
    end
  end
end
