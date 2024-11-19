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
      # We use the associated scope to ensure that the page_embedding
      # association exists when querying the related pages, otherwise, the MATCH
      # embedding subquery will raise an ActiveRecord::StatementInvalid error;
      # there needs to be an embedding to match against!
      #
      scope :similar_to, ->(page) do
        similar_page_subquery = PageEmbedding
          .where("embedding MATCH (?)", PageEmbedding.select(:embedding).where(id: page.id))
          .select(:id, :distance)
          .order(distance: :asc)
          .limit(10)

        where.associated(:page_embedding)
          .select("pages.*")
          .select("similar_pages.distance")
          .from("(#{similar_page_subquery.to_sql}) similar_pages")
          .joins("LEFT JOIN pages ON similar_pages.id = pages.id")
          .where("similar_pages.id != ?", page.id)
          .order("similar_pages.distance ASC")
      end
    end
  end
end
