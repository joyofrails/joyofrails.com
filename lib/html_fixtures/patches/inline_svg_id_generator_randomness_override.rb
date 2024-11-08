module HtmlFixtures
  module Patches
    module InlineSvgIdGeneratorRandomnessOverride
      def call
        "non-random-for-fixtures"
      end
    end
  end
end

# We use this module to override the randomness of the InlineSvg gem to ensure that the SVG
# IDs are consistent across test runs and git commits in the generated HTML fixtures.
#
# Overrides this behavior: https://github.com/jamesmartin/inline_svg/blob/9ab5ccf8d4ba6a6d1e453d9bde2008a6ebab9877/lib/inline_svg/id_generator.rb#L5-L10
#
class InlineSvg::IdGenerator::Randomness
  class << self
    prepend HtmlFixtures::Patches::InlineSvgIdGeneratorRandomnessOverride
  end
end
