require "rails_helper"

RSpec.describe Pages::EmbeddingJob, type: :job do
  it "updates page emebedding for given page" do
    page = Page.find_or_create_by!(request_path: "/articles/custom-color-schemes-with-ruby-on-rails")

    response = {
      object: "list",
      data: [
        object: "embedding",
        index: 0,
        embedding: PageEmbedding.random
      ],
      model: "text-embedding-3-small",
      usage: {
        prompt_tokens: 1446,
        total_tokens: 1446
      }
    }

    stub_request(:post, "https://api.openai.com/v1/embeddings")
      .with(body: {model: "text-embedding-3-small", input: page.body_text})
      .to_return(json_response(response))

    expect {
      Pages::EmbeddingJob.perform_now(page)
    }.to change(PageEmbedding, :count).by(1)

    page_embedding = PageEmbedding.last

    expect(page_embedding.page).to eq page
    expect(page_embedding.embedding).to be_a(Array)
    expect(page_embedding.embedding.length).to eq(PageEmbedding::OPENAI_EMBEDDING_LENGTH)
  end
end
