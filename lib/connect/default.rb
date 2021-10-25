# frozen_string_literal: true

require "connect/version"

module Connect
  module Default
    API_ENDPOINT = "https://localhost:8901/v1"
    USER_AGENT = "1Password Connect Ruby Gem #{Connect::VERSION}"

    class << self
      def options
        Connect::Configurable.keys.map { |key| [key, send(key)] }.to_h
      end

      def access_token
        ENV["CONNECT_ACCESS_TOKEN"]
      end

      def adapter
        Faraday.default_adapter
      end

      def api_endpoint
        ENV["CONNECT_API_ENDPOINT"] || API_ENDPOINT
      end

      def stubs
      end

      def user_agent
        ENV["CONNECT_USER_AGENT"] || USER_AGENT
      end
    end
  end
end
