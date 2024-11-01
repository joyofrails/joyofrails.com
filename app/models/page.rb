# frozen_string_literal: true

# ActiveRecord model to represent a static page in the database.
class Page < ApplicationRecord
  after_create_commit :create_in_search_index
  after_update_commit :update_in_search_index
  after_destroy_commit :remove_from_search_index

  # The pages_search_index table is a full-text search index for the pages
  # table. FTS5 tables contain a hidden 'rank' column that is (hand waving) a
  # relevancy score for sorting search results.
  # https://www.sqlite.org/fts5.html#sorting_by_auxiliary_function_results
  #
  scope :ranked, -> { order(:rank) }

  # snippet() is a SQLite function that returns a snippet of text containing the search term.
  # It’s used to highlight search results. The snippet() function is not
  # available in all databases, so this scope is only available for SQLite as
  # part of the FTS5 extension.
  # https://www.sqlite.org/fts5.html#the_snippet_function
  #
  scope :with_snippets, ->(**options) do
    select("#{table_name}.*")
      .select("snippet(pages_search_index, 0, '<mark>', '</mark>', '…', 32) AS title_snippet")
      .select("snippet(pages_search_index, 1, '<mark>', '</mark>', '…', 32) AS body_snippet")
  end

  def self.search(query)
    joins("JOIN pages_search_index ON pages.id = pages_search_index.page_id")
      .where("pages_search_index MATCH ?", query)
  end

  def self.refresh_search_index
    find_each(&:update_in_search_index)
  end

  def title
    resource.data.title
  end

  def body
    resource.body
  end

  def body_html
    ApplicationController.render(
      inline: body,
      type: (resource.handler.to_sym == :mdrb) ? :"mdrb-atom" : resource.handler,
      layout: false,
      content_type: "application/atom+xml",
      assigns: {
        format: :atom
      }
    )
  end

  def body_text
    Nokogiri::HTML(body_html).text.squish
  end

  def resource
    Sitepress.site.get(request_path)
  end

  def create_in_search_index
    Rails.logger.info "[#{self.class}] Creating search index for page #{id} #{request_path}"
    execute_sanitized_sql "INSERT INTO pages_search_index (page_id, title, body) VALUES (?, ?, ?)", id, title, body_text
  end

  def update_in_search_index
    transaction do
      remove_from_search_index
      create_in_search_index
    end
  end

  def remove_from_search_index
    execute_sanitized_sql "DELETE FROM pages_search_index WHERE page_id = ?", id
  end

  def execute_sanitized_sql(*statement)
    execute self.class.sanitize_sql(statement)
  end

  def execute(statement)
    self.class.connection.execute statement
  end
end
