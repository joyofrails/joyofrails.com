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
      # There may be a better way to handle this, but we have an extra query to
      # make sure the given page has an associated page_embedding, otherwise the
      # embedding MATCH subquery will fail with an invalid statement error.
      #
      scope :similar_to, ->(page) do
        return none unless page.page_embedding

        similar_page_subquery = PageEmbedding
          .where("embedding MATCH (?)", PageEmbedding.select(:embedding).where(id: page.id))
          .select(:id, :distance)
          .order(distance: :asc)
          .limit(10)

        select("pages.*")
          .select("similar_pages.distance")
          .from("(#{similar_page_subquery.to_sql}) similar_pages")
          .joins("INNER JOIN pages ON similar_pages.id = pages.id")
          .where("similar_pages.id != ?", page.id)
          .order("similar_pages.distance ASC")
      end
    end
  end
end
