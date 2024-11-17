module Pages
  class EmbeddingJob < ApplicationJob
    queue_as :default

    def perform(page)
      response = client.embeddings(
        parameters: {
          model: "text-embedding-3-small",
          input: page.body_text
        }
      )

      # Embedding is an array of 1536 floats
      embedding = response.dig("data", 0, "embedding")

      PageEmbedding.upsert_embedding!(page, embedding)

      embedding
    end

    def client
      OpenAI::Client.new
    end
  end
end
