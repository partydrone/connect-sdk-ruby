require "test_helper"

describe OpConnect::Client do
  subject { OpConnect::Client }

  before do
    OpConnect.reset!
  end

  after do
    OpConnect.reset!
  end

  describe "module configuration" do
    before do
      OpConnect.reset!
      OpConnect.configure do |config|
        OpConnect::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      OpConnect.reset!
    end

    it "inherits the module configuration" do
      client = subject.new

      OpConnect::Configurable.keys.each do |key|
        _(client.instance_variable_get(:"@#{key}")).must_equal "Some #{key}"
      end
    end

    describe "with class-level configuration" do
      before do
        @options = {
          access_token: "some-new-access_token",
          api_endpoint: "https://api.bogus.zzz/v1"
        }
      end

      it "overrides module configuration" do
        client = subject.new(@options)

        _(client.access_token).must_equal "some-new-access_token"
        _(client.api_endpoint).must_equal "https://api.bogus.zzz/v1/"
      end

      it "can set configuration after initialization" do
        client = subject.new
        client.configure do |config|
          @options.each do |key, value|
            config.send("#{key}=", value)
          end
        end

        _(client.access_token).must_equal "some-new-access_token"
        _(client.api_endpoint).must_equal "https://api.bogus.zzz/v1/"
      end

      it "masks tokens on inspect" do
        client = subject.new(access_token: "OPExnRuUZtQe6I9QtSNY5j5BrrnU")
        inspected = client.inspect
        _(inspected).wont_include "OPExnRuUZtQe6I9QtSNY5j5BrrnU"
      end
    end
  end

  describe ".last_response" do
    it "caches the last agent response" do
      OpConnect.reset!

      stub = Faraday::Adapter::Test::Stubs.new
      stub.get("/v1/heartbeat") { [200, {}, ""] }
      client = subject.new(access_token: "fake", adapter: :test, stubs: stub)

      _(client.last_response).must_be_nil

      client.get("heartbeat")

      _(client.last_response.status).must_equal 200
    end
  end

  describe ".get" do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }

    before do
      OpConnect.reset!
    end

    it "handles query params" do
      stubs.get("/heartbeat?foo=bar") do |env|
        _(env.url.query).must_equal "foo=bar"
        [200, {}, ""]
      end
    end

    it "handles headers"
  end

  describe "when making requests" do
    it "sets a deafult user agent"
    it "sets a custom user agent"
  end

  describe "utility methods" do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:client) { subject.new(access_token: "fake", adapter: :test, stubs: stubs) }

    describe "activity" do
      it "returns a list of API requests" do
        stubs.get("/v1/activity") { [200, {"Content-Type": "application/json"}, fixture("activity.json")] }

        api_request = client.activity.first

        _(api_request).must_be_instance_of OpConnect::APIRequest
        _(api_request.action).must_equal "READ"
      end
    end

    describe "heartbeat" do
      it "returns true if the server is active" do
        stubs.get("/heartbeat") { [200, {"Content-Type": "text/plain"}, "."] }

        _(client.heartbeat).must_equal true
      end

      it "returns false if the servier is not active" do
        stubs.get("/heartbeat") { [500, {}, ""] }

        _(client.heartbeat).must_equal false
      end
    end

    describe "health" do
      it "returns the state of the server" do
        stubs.get("/health") { [200, {"Content-Type": "application/json"}, fixture("health.json")] }

        _(client.health).must_be_instance_of OpConnect::ServerHealth
        _(client.health.name).must_equal "1Password Connect API"
      end
    end

    describe "metrics" do
      it "returns metrics collected by the server" do
        stubs.get("/metrics") { [200, {"Content-Type": "text/plain"}, fixture("metrics.txt")] }

        _(client.metrics).must_equal "Metrics go here!\n"
      end
    end
  end

  describe "error handling" do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:client) { subject.new(access_token: "fake", adapter: :test, stubs: stubs) }

    it "raises on 400" do
      stubs.get("/v1/whatever") { [400, {"Content-Type": "application/json"}, fixture("errors/400.json")] }

      _ { client.get("whatever") }.must_raise OpConnect::BadRequest
    end

    it "raises on 401" do
      stubs.get("/v1/who_are_you") { [401, {"Content-Type": "application/json"}, fixture("errors/401.json")] }

      _ { client.get("who_are_you") }.must_raise OpConnect::Unauthorized
    end

    it "raises on 403" do
      stubs.get("/v1/nope") { [403, {"Content-Type": "application/json"}, fixture("errors/403.json")] }

      _ { client.get("nope") }.must_raise OpConnect::Forbidden
    end

    it "raises on 404" do
      stubs.get("/v1/not_found") { [404, {"Content-Type": "application/json"}, fixture("errors/404.json")] }

      _ { client.get("not_found") }.must_raise OpConnect::NotFound
    end

    it "raises on 413" do
      stubs.get("/v1/too_big") { [413, {"Content-Type": "application/json"}, fixture("errors/413.json")] }

      _ { client.get("too_big") }.must_raise OpConnect::PayloadTooLarge
    end

    it "raises on 500" do
      stubs.get("/v1/server_error") { [500, {}, ""] }

      _ { client.get("server_error") }.must_raise OpConnect::InternalServerError
    end

    it "raises on 503" do
      stubs.get("/v1/service_unavailable") { [503, {}, ""] }

      _ { client.get("service_unavailable") }.must_raise OpConnect::ServiceUnavailable
    end
  end
end
