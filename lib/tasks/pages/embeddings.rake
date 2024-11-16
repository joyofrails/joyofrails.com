namespace :embeddings do
  desc "Upsert random embeddings for lack of OpenAI connection"
  task upsert_random: :environment do
    Page.published.find_each do |page|
      PageEmbedding.upsert_embedding!(page, PageEmbedding.random)
    end
  end
end
