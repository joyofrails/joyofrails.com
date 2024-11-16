class Page
  module Similarity
    extend ActiveSupport::Concern

    included do
      has_one :page_embedding, inverse_of: :page, foreign_key: :id, primary_key: :id

      scope :similar_to, ->(page) do
        select("pages.*")
          .select("similar_pages.distance")
          .from("(#{PageEmbedding.similar_to(page.page_embedding).to_sql}) similar_pages")
          .joins("LEFT JOIN pages ON similar_pages.id = pages.id")
          .where("similar_pages.id != ?", page.id)
          .order("similar_pages.distance ASC")
      end
    end

    # def related_articles
    #   return self.class.none unless page_embedding
    #   self.class.similar_to(self)
    # end
  end
end
