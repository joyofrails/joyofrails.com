require "rails_helper"

RSpec.describe Share::SnippetsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/share/snippets").to route_to("share/snippets#index")
    end

    it "routes to #new" do
      expect(get: "/share/snippets/new").to route_to("share/snippets#new")
    end

    it "routes to #show" do
      expect(get: "/share/snippets/1").to route_to("share/snippets#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/share/snippets/1/edit").to route_to("share/snippets#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/share/snippets").to route_to("share/snippets#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/share/snippets/1").to route_to("share/snippets#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/share/snippets/1").to route_to("share/snippets#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/share/snippets/1").to route_to("share/snippets#destroy", id: "1")
    end
  end
end
