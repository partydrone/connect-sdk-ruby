# frozen_string_literal: true

require "op_connect/version"

module OpConnect
  # Default configuration options for {Client}
  #
  module Default
    API_ENDPOINT = "http://localhost:8080/v1"
    USER_AGENT = "1Password Connect Ruby Gem #{OpConnect::VERSION}"

    class << self
      # Configuration options
      #
      # @return [Hash]
      #
      def options
        OpConnect::Configurable.keys.map { |key| [key, send(key)] }.to_h
      end

      # Default access token from ENV
      #
      # @return [String]
      #
      def access_token
        ENV["OP_CONNECT_ACCESS_TOKEN"]
      end

      # Default network adapter for Faraday (defaults to :net_http)
      #
      # @return [Symbol]
      #
      def adapter
        Faraday.default_adapter
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      #
      # @return [<Type>] <description>
      #
      def api_endpoint
        ENV["OP_CONNECT_API_ENDPOINT"] || API_ENDPOINT
      end

      def stubs
      end

      # Default user agent from ENV or {USER_AGENT}
      #
      # @return [<Type>] <description>
      #
      def user_agent
        ENV["OP_CONNECT_USER_AGENT"] || USER_AGENT
      end
    end
  end
end
