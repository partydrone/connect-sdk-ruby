# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

# Ruby toolkit for the 1Password Connect REST API.
#
module Connect
  autoload :Configurable, "connect/configurable"
  autoload :Default, "connect/default"

  class << self
    include Connect::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [Connect::Client] API wrapper
    #
    def client
      return @client if defined?(@client) && @client.same_options?(options)
      @client = Connect::Client.new(options)
    end
  end
end

Connect.setup
