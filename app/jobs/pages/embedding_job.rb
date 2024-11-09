module Pages
  class EmbeddingJob < ApplicationJob
    queue_as :default

    def perform(page)
      response = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: page.body_text
        }
      )

      embedding = response.dig("data", 0, "embedding")

      if Rails.env.development?
        file = Rails.root.join("config", "embeddings.yml")
        data = {
          page_id: page.id,
          embedding: embedding
        }

        File.write(file, YAML.dump(YAML.load_file(file).merge!(data)))
      end

      PageEmbedding.update_embedding(page, embedding)

      embedding
    end

    def client
      OpenAI::Client.new
    end
  end
end
