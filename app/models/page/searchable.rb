class Page
  module Searchable
    extend ActiveSupport::Concern

    Error = Class.new(StandardError)
    ConfigurationError = Class.new(Error)

    included do
      after_create_commit :create_in_search_index
      after_update_commit :update_in_search_index
      after_destroy_commit :remove_from_search_index

      scope :search, ->(query) do
        join_search_index.where("pages_search_index MATCH ?", query)
      end

      # The pages_search_index table is a full-text search index for the pages
      # table. FTS5 tables contain a hidden 'rank' column that is (hand waving) a
      # relevancy score for sorting search results.
      # https://www.sqlite.org/fts5.html#sorting_by_auxiliary_function_results
      #
      scope :ranked, -> { order(:rank) }

      # The with_snippets scope is used to add a snippet of text to search results.
      # It requires a join to the search index table.
      #
      # snippet() is a SQLite function that returns a snippet of text containing the search term.
      # It’s used to highlight search results. The snippet() function is not
      # available in all databases, so this scope is only available for SQLite as
      # part of the FTS5 extension.
      # https://www.sqlite.org/fts5.html#the_snippet_function
      #
      scope :with_snippets, -> do
        select("pages.*")
          .join_search_index
          .select("snippet(pages_search_index, 0, '<mark>', '</mark>', '…', 32) AS title_snippet")
          .select("snippet(pages_search_index, 1, '<mark>', '</mark>', '…', 32) AS body_snippet")
      end

      scope :join_search_index, -> do
        joins("JOIN pages_search_index ON pages.id = pages_search_index.page_id")
      end
    end

    def create_in_search_index
      self.class.create_search_index(self)
    end

    def update_in_search_index
      transaction do
        remove_from_search_index
        create_in_search_index
      end
    end

    def remove_from_search_index
      self.class.remove_from_search_index(self)
    end

    module ClassMethods
      def refresh_search_index
        find_each(&:update_in_search_index)
      end

      def create_search_index(page)
        id, title, body = [:id, :title, :body_text].map { |attr| page.send(attr) }
        Rails.logger.info "[#{self}] Creating search index: #{id} #{title}"

        # Order of columns must match the order of columns in the search index
        connection.execute sanitize_sql([<<~SQL.squish, title, body, id])
          INSERT INTO pages_search_index (title, body, page_id)
          VALUES (?, ?, ?)
        SQL
      end

      def remove_from_search_index(page)
        connection.execute sanitize_sql([<<~SQL.squish, page.id])
          DELETE FROM pages_search_index
          WHERE page_id = ?
        SQL
      end
    end
  end
end
