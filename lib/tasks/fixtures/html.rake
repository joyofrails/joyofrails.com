namespace :fixtures do
  task html: :environment do
    if Rails.env.local?
      class InlineSvg::IdGenerator::Randomness
        class << self
          prepend InlineSvgIdGeneratorRandomnessOverrideForFixtures
        end
      end
    end

    File.write(Rails.root.join("app", "javascript", "test", "fixtures", "views", "darkmode", "switch.html"), ApplicationController.render(partial: "darkmode/switch"))
  end
end

module InlineSvgIdGeneratorRandomnessOverrideForFixtures
  def call
    "non-random-for-fixtures"
  end
end
