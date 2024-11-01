module Searchable
  extend ActiveSupport::Concern

  included do
    after_create_commit :create_in_search_index
    after_update_commit :update_in_search_index
    after_destroy_commit :remove_from_search_index

    scope :search, ->(query) do
      join_search_index.where("#{search_table_name} MATCH ?", query)
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
    scope :with_snippets, ->(*columns) do
      snippet_columns = search_index_mapping.keys.map(&:to_s) & columns.map(&:to_s)
      scope = select("#{table_name}.*").join_search_index
      snippet_columns.each.with_index do |column, column_index|
        scope = scope.select("snippet(#{search_table_name}, #{column_index}, '<mark>', '</mark>', '…', 32) AS #{column}_snippet")
      end
      scope
    end

    scope :join_search_index, -> do
      joins("JOIN #{search_table_name} ON #{table_name}.id = #{search_table_name}.#{search_table_foreign_key}")
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

    def create_search_index(searchable)
      values = search_index_mapping.values.map { |method| searchable.send(method) }
      insert_pairs = search_index_columns.zip(values).to_h

      Rails.logger.info "[#{self}] Creating search index: #{insert_pairs}"

      connection.execute sanitize_sql([<<~SQL.squish, *insert_pairs.values])
        INSERT INTO #{search_table_name} (#{insert_pairs.keys.join(", ")})
        VALUES (#{insert_pairs.map { "?" }.join(", ")})
      SQL
    end

    def remove_from_search_index(searchable)
      connection.execute sanitize_sql([<<~SQL.squish, searchable.id])
        DELETE FROM #{search_table_name}
        WHERE #{search_table_foreign_key} = ?
      SQL
    end

    # Order is important here. The search snippet query needs to know the index of the columns.
    def search_index_mapping
      {
        title: :title,
        body: :body_text,
        page_id: :id
      }
    end

    def search_index_columns
      search_index_mapping.keys.map(&:to_s)
    end

    def search_table_name
      "#{table_name}_search_index"
    end

    # The foreign key in the search table that links to the primary key of the
    # main table.  FTS5 supports a "rowid" column that can be used as a primary
    # key, but it expects to be an integer.  If the primary key is a UUID/ULID,
    # as it is for the Page model, we need to maintain a separate column in the
    # search index to act as the foreign key.
    #
    # https://www.sqlite.org/fts5.html#external_content_tables
    #
    def search_table_foreign_key
      "#{table_name.singularize}_id"
    end
  end
end
