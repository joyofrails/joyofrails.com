require "rails_helper"

RSpec.describe ApplicationClient do
  subject(:client) { described_class.new(token: "test") }

  it "authorization header" do
    stub_request(:get, "https://example.org/").with(headers: {"Authorization" => "Bearer test"})
    assert_nothing_raised do
      client.send(:get, "/")
    end
  end

  it "basic auth" do
    stub_request(:get, "https://example.org/")
    client = ApplicationClient.new(basic_auth: {username: "user", password: "pass"})
    client.send(:get, "/")
    assert_requested(:get, "https://example.org/", headers: {"Authorization" => "Basic #{Base64.strict_encode64("user:pass")}"})
  end

  it "get" do
    stub_request(:get, "https://example.org/test")
    assert_nothing_raised do
      client.send(:get, "/test")
    end
  end

  it "get with query params" do
    stub_request(:get, "https://example.org/test").with(query: {"foo" => "bar"})
    assert_nothing_raised do
      client.send(:get, "/test", query: {foo: "bar"})
    end
  end

  it "get with query params as a string" do
    stub_request(:get, "https://example.org/test").with(query: {"foo" => "bar"})
    assert_nothing_raised do
      client.send(:get, "/test", query: "foo=bar")
    end
  end

  it "override BASE_URI by passing in full url" do
    stub_request(:get, "https://other.org/test")
    assert_nothing_raised do
      client.send(:get, "https://other.org/test")
    end
  end

  it "post" do
    stub_request(:post, "https://example.org/test").with(body: {"foo" => {"bar" => "baz"}}.to_json)
    assert_nothing_raised do
      client.send(:post, "/test", body: {foo: {bar: "baz"}})
    end
  end

  it "post with string body" do
    stub_request(:post, "https://example.org/test").with(body: "foo")
    assert_nothing_raised do
      client.send(:post, "/test", body: "foo")
    end
  end

  it "post with custom content-type" do
    headers = {"Content-Type" => "application/x-www-form-urlencoded"}
    stub_request(:post, "https://example.org/test").with(body: {"foo" => "bar"}.to_json, headers: headers)
    assert_nothing_raised do
      client.send(:post, "/test", body: {foo: "bar"}, headers: headers)
    end
  end

  it "multipart form data with file_fixture" do
    file = file_fixture("avatar.jpg")
    form_data = {
      "field1" => "value1",
      "file" => File.open(file)
    }

    stub_request(:post, "https://example.org/upload").to_return(status: 200)
    assert_nothing_raised do
      client.send(:post, "/upload", form_data: form_data)
    end
  end

  it "patch" do
    stub_request(:patch, "https://example.org/test").with(body: {"foo" => "bar"}.to_json)
    assert_nothing_raised do
      client.send(:patch, "/test", body: {foo: "bar"})
    end
  end

  it "multipart form data with file_fixture and patch" do
    file = file_fixture("avatar.jpg")

    form_data = {
      "field1" => "value1",
      "file" => File.open(file)
    }

    stub_request(:patch, "https://example.org/update").to_return(status: 200)

    assert_nothing_raised do
      client.send(:patch, "/update", form_data: form_data)
    end
  end

  it "put" do
    stub_request(:put, "https://example.org/test").with(body: {"foo" => "bar"}.to_json)
    assert_nothing_raised do
      client.send(:put, "/test", body: {foo: "bar"})
    end
  end

  it "multipart form data with file_fixture and put" do
    file = file_fixture("avatar.jpg")

    form_data = {
      "field1" => "value1",
      "file" => File.open(file)
    }

    stub_request(:put, "https://example.org/update").to_return(status: 200)

    assert_nothing_raised do
      client.send(:put, "/update", form_data: form_data)
    end
  end

  it "delete" do
    stub_request(:delete, "https://example.org/test")
    assert_nothing_raised do
      client.send(:delete, "/test")
    end
  end

  it "response object parses json" do
    stub_request(:get, "https://example.org/test").to_return(body: {"foo" => "bar"}.to_json, headers: {content_type: "application/json"})
    result = client.send(:get, "/test")
    assert_equal "200", result.code
    assert_equal "application/json", result.content_type
    assert_equal "bar", result.foo
  end

  it "response object parses xml" do
    stub_request(:get, "https://example.org/test").to_return(body: {"foo" => "bar"}.to_xml, headers: {content_type: "application/xml"})
    result = client.send(:get, "/test")
    assert_equal "200", result.code
    assert_equal "application/xml", result.content_type
    assert_equal "bar", result.xpath("//foo").children.first.to_s
  end

  it "unauthorized" do
    stub_request(:get, "https://example.org/test").to_return(status: 401)
    assert_raises ApplicationClient::Unauthorized do
      client.send(:get, "/test")
    end
  end

  it "forbidden" do
    stub_request(:get, "https://example.org/test").to_return(status: 403)
    assert_raises ApplicationClient::Forbidden do
      client.send(:get, "/test")
    end
  end

  it "not found" do
    stub_request(:get, "https://example.org/test").to_return(status: 404)
    assert_raises ApplicationClient::NotFound do
      client.send(:get, "/test")
    end
  end

  it "rate limit" do
    stub_request(:get, "https://example.org/test").to_return(status: 429)
    assert_raises ApplicationClient::RateLimit do
      client.send(:get, "/test")
    end
  end

  it "internal error" do
    stub_request(:get, "https://example.org/test").to_return(status: 500)
    assert_raises ApplicationClient::InternalError do
      client.send(:get, "/test")
    end
  end

  it "other error" do
    stub_request(:get, "https://example.org/test").to_return(status: 418)
    assert_raises ApplicationClient::Error do
      client.send(:get, "/test")
    end
  end

  it "parses link header" do
    stub_request(:get, "https://example.org/pages").to_return(headers: {"Link" => "<https://example.org/pages?page=2>; rel=\"next\", <https://example.org/pages?page=1>; rel=\"prev\""})
    response = client.send(:get, "/pages")
    assert_equal "https://example.org/pages?page=2", response.link_header[:next]
    assert_equal "https://example.org/pages?page=1", response.link_header[:prev]
  end

  it "handles missing link header" do
    stub_request(:get, "https://example.org/pages")
    response = client.send(:get, "/pages")
    assert_empty(response.link_header)
  end

  describe "with basic auth" do
    subject(:client) { basic_auth_class.new }

    let(:basic_auth_class) do
      Class.new(ApplicationClient) do
        base_uri "https://example.org"

        def basic_auth
          {username: "user", password: "pass"}
        end
      end
    end

    it "uses basic auth" do
      stub_request(:get, "https://example.org/")
      client.send :get, "/"
      assert_requested(:get, "https://example.org/", headers: {"Authorization" => "Basic #{Base64.strict_encode64("user:pass")}"})
    end
  end

  describe "with pagination" do
    let(:paginated_client_class) do
      Class.new(ApplicationClient) do
        base_uri "https://test.example.org"

        def root
          get "/"
        end

        def content_type
          "application/xml"
        end

        def all_pages
          with_pagination("/pages", query: {per_page: 100}) do |response|
            response.link_header[:next]
          end
        end

        def all_projects
          with_pagination("/projects", query: {per_page: 100}) do |response|
            next_page = response.parsed_body.pagination.next_page
            {page: next_page} if next_page
          end
        end
      end
    end

    it "with_pagination and url" do
      stub_request(:get, "https://test.example.org/pages?per_page=100").to_return(headers: {"Link" => "<https://test.example.org/pages?page=2>; rel=\"next\""})
      stub_request(:get, "https://test.example.org/pages?per_page=100&page=2")
      assert_nothing_raised do
        paginated_client_class.new(token: "test").all_pages
      end
    end

    it "with_pagination with query hash" do
      stub_request(:get, "https://test.example.org/projects?per_page=100").to_return(body: {pagination: {next_page: 2}}.to_json, headers: {content_type: "application/json"})
      stub_request(:get, "https://test.example.org/projects?per_page=100&page=2").to_return(body: {pagination: {prev_page: 1}}.to_json, headers: {content_type: "application/json"})
      assert_nothing_raised do
        paginated_client_class.new(token: "test").all_projects
      end
    end

    it "get" do
      stub_request(:get, "https://test.example.org/")
      assert_nothing_raised do
        paginated_client_class.new(token: "test").root
      end
    end

    it "content type" do
      stub_request(:get, "https://test.example.org/").with(headers: {"Accept" => "application/xml"})
      assert_nothing_raised do
        paginated_client_class.new(token: "test").root
      end
    end

    it "other error" do
      stub_request(:get, "https://test.example.org/").to_return(status: 418)
      assert_raises paginated_client_class::Error do
        paginated_client_class.new(token: "test").root
      end
    end
  end
end
