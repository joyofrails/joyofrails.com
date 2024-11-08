# frozen_string_literal: true

class SearchesController < ApplicationController
  rescue_from Searches::ParseFailed do |error|
    query = params.fetch(:query, "")

    respond_to do |format|
      format.html { render Searches::ShowView.new(query:, name:) }
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace(Searches::Listbox.dom_id(name), Searches::Listbox.new(query:, name:))
        ]
      }
    end
  end

  def show
    results = if query.present?
      parsed_query = Searches::Query.parse!(query)
      Page.search("#{parsed_query}*").with_snippets.ranked.limit(3)
    else
      []
    end

    respond_to do |format|
      format.html { render Searches::ShowView.new(results:, query:) }

      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace(
            Searches::Listbox.dom_id(name),
            Searches::Listbox.new(results:, query:, name:)
          )
        ]
      }
    end
  end

  private

  def query
    params.fetch(:query, "")
  end

  def name
    params.fetch(:name, "search")
  end
end
