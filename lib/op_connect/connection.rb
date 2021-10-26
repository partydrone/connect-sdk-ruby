module OpConnect
  # Network layer for API clients.
  #
  module Connection
    # Make an HTTP GET request.
    #
    # @param url [String] The path, relative to {#api_endpoint}.
    # @param params [Hash] Query parameters for the request.
    # @param headers [Hash] Header params for the request.
    #
    # @return [Faraday::Response]
    #
    def get(url, params: {}, headers: {})
      request :get, url, params, headers
    end

    # Make an HTTP POST request.
    #
    # @param url [String] The path, relative to {#api_endpoint}.
    # @param body [Hash] Body params for the request.
    # @param headers [Hash] Header params for the request.
    #
    # @return [Faraday::Response]
    #
    def post(url, body:, headers: {})
      request :post, url, body, headers
    end

    # Make an HTTP PUT request.
    #
    # @param url [String] The path, relative to {#api_endpoint}.
    # @param body [Hash] Body params for the request.
    # @param headers [Hash] Header params for the request.
    #
    # @return [Faraday::Response]
    #
    def put(url, body:, headers: {})
      request :put, url, body, headers
    end

    # Make an HTTP PATCH request.
    #
    # @param url [String] The path, relative to {#api_endpoint}.
    # @param body [Hash] Body params for the request.
    # @param headers [Hash] Header params for the request.
    #
    # @return [Faraday::Response]
    #
    def patch(url, body:, headers: {})
      request :patch, url, body, headers
    end

    # Make an HTTP DELETE request.
    #
    # @param url [String] The path, relative to {#api_endpoint}.
    # @param params [Hash] Query params for the request.
    # @param headers [Hash] Header params for the request.
    #
    # @return [Faraday::Response]
    #
    def delete(url, params: {}, headers: {})
      request :delete, url, params, headers
    end

    # Connection object for the 1Password Connect API.
    #
    # @return [Faraday::Client]
    #
    def connection
      @connection ||= Faraday.new(api_endpoint) do |http|
        http.headers[:user_agent] = user_agent

        http.request :authorization, :Bearer, access_token
        http.request :json

        http.use OpConnect::Response::RaiseError

        http.response :dates
        http.response :json, content_type: "application/json"
        http.response :logger do |logger|
          logger.filter(/(Bearer) (\w+)/, '\1 [FILTERED]')
        end

        http.adapter adapter, @stubs
      end
    end

    # Response for the last HTTP request.
    #
    # @return [Faraday::Response]
    #
    def last_response
      @last_response if defined? @last_response
    end

    private

    def request(method, path, data, headers = {})
      @last_response = response = connection.send(method, path, data, headers)
      response
    rescue OpConnect::Error => error
      @last_response = nil
      raise error
    end
  end
end
