module Refinements
  module Emojoy
    EMOJOYS = %w[🎸 🚴🏼‍♂️ 🛜 🍿 👻 🤠 ✌️ 🦸🏻‍♀️ 🐙 🌈 ⚡️ 🔥 🏆].freeze

    refine String do
      def emojoy
        self + " #{EMOJOYS.sample}"
      end
    end
  end
end
