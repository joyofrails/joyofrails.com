require "rails_helper"

RSpec.describe "/examples/counters", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Examples::Counter. As you add validations to Examples::Counter, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      count: 2
    }
  }

  let(:invalid_attributes) {
    {
      nonsense: 2
    }
  }

  describe "GET /show" do
    it "renders a successful response" do
      get examples_counters_url
      expect(response).to be_successful
    end
  end

  describe "PUT /update" do
    context "with valid parameters" do
      let(:new_attributes) { valid_attributes }

      it "updates the requested examples_counter" do
        patch examples_counters_url, params: {counter: new_attributes}
        expect(session[:examples_counter]).to eq(new_attributes[:count])
      end

      it "redirects to the examples_counter" do
        patch examples_counters_url, params: {counter: new_attributes}
        expect(response).to redirect_to(examples_counters_url)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested examples_counter" do
      delete examples_counters_url
      expect(session[:examples_counter]).to be_nil
    end

    it "redirects to the examples_counts list" do
      delete examples_counters_url
      expect(response).to redirect_to(examples_counters_url)
    end
  end
end
