module Searches
  class Listbox < ApplicationComponent
    include Phlex::Rails::Helpers::DOMID

    attr_reader :results, :query, :name

    def self.dom_id(name)
      "#{name}-listbox"
    end

    def initialize(results: [], query: "", name: "search")
      @results = results
      @query = query
      @name = name
    end

    def view_template
      ul(**mix(
        id: listbox_dom_id,
        role: "listbox",
        class: ["grid"],
        data: {
          controller: "search-listbox"
        }
      )) do
        # Using `results.present?` instead of `results.any?` is a concious decision to avoid an extra "SELECT 1" query
        # For more information, see: https://www.speedshop.co/2019/01/10/three-activerecord-mistakes.html#any-exists-and-present
        if results.present?
          results.each.with_index do |result, i|
            li(
              aria: {label: result.title},
              role: "option",
              id: dom_id(result, "search-option"),
              class: "rounded"
            ) do
              render Searches::Result.new(result)
            end
          end
        elsif query_long_enough?
          li(class: "p-2") do
            p(class: "pb-2") { "No results 😬" }
            p(class: "pb-2 step--2") do
              "Search function is new, bear with me 🧸."
            end
            p(class: "step--2") do
              plain "Please"
              whitespace
              a(href: "/contact") { "reach out" }
              whitespace
              plain "if you’d like to see me address an unlisted topic."
            end
          end
        end
      end
    end

    def query_long_enough?
      query && query.length > 2
    end

    def listbox_dom_id
      self.class.dom_id(@name)
    end
  end
end
