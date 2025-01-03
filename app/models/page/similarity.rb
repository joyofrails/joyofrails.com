class Page
  module Similarity
    extend ActiveSupport::Concern

    included do
      has_one :page_embedding, inverse_of: :page, foreign_key: :id, primary_key: :id

      # We unscope(:where) because we want to disable the default association
      # behavior of scoping where(id: page.id) for querying related pages not
      # including the page itself.
      #
      has_many :related_pages,
        ->(page) { unscope(:where).similar_to(page) },
        class_name: "Page", foreign_key: :id, primary_key: :id

      # Here’s an exciting query. This is how we find related pages using the
      # PageEmbedding virtual table with the sqlite-vec extension.
      #
      # We’re using a subquery to find the embeddings that match the embedding
      # of the given page. We then join the pages table to the subquery to get
      # the related pages. We order by the distance between the embeddings and
      # exclude the page itself.
      #
      # The subquery to find the embeddings that match the given page uses the
      # sqlite-vec extension under the hood. sqlite-vec wants the subquery to
      # specify a LIMIT when used in this way. This limit is currently
      # hard-coded. When we have more articles we may want to make this limit
      # configurable.
      #
      # There may be a better way to handle this, but we have an extra query to
      # make sure the given page has an associated page_embedding, otherwise the
      # embedding MATCH subquery will fail with an invalid statement error.
      #
      scope :similar_to, ->(page) do
        return none unless page.page_embedding

        select(pages: column_names, similar_embeddings: [:distance])
          .with(
            similar_embeddings: PageEmbedding
              .similar_to(page)
              .order(distance: :asc)
              .limit(10)
          )
          .joins("INNER JOIN similar_embeddings ON pages.id = similar_embeddings.id")
          .excluding(page)
          .order(distance: :asc)
      end
    end
  end
end
