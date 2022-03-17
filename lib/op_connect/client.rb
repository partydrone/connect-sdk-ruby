module OpConnect
  # Client for the OpConnect API.
  #
  class Client
    autoload :Vaults, "op_connect/client/vaults"
    autoload :Items, "op_connect/client/items"
    autoload :Files, "op_connect/client/files"

    include OpConnect::Configurable
    include OpConnect::Connection
    include OpConnect::Client::Vaults
    include OpConnect::Client::Items
    include OpConnect::Client::Files

    def initialize(options = {})
      OpConnect::Configurable.keys.each do |key|
        value = options.key?(key) ? options[key] : OpConnect.instance_variable_get(:"@#{key}")
        instance_variable_set(:"@#{key}", value)
      end
    end

    # Text representation of the client, masking tokens.
    #
    # @return [String]
    #
    def inspect
      inspected = super
      inspected.gsub!(@access_token, ("*" * 24).to_s) if @access_token
      inspected
    end

    # Retrieve a list of API requests that have been made.
    #
    # @param params [Hash] Optional parameters.
    # @option params [Integer] :limit How many API Events should be returned
    #   in a single request.
    # @option params [Integer] :offset How far into the collection of API
    #   Events should the response start.
    #
    # @return [Array<APIRequest>]
    #
    def activity(**params)
      get("activity", params: params).body.map { |a| APIRequest.new(a) }
    end

    # Simple "ping" endpoint to check whether the server is active.
    #
    # @return [Boolean] Returns true if the server is active, false otherwise.
    #
    def heartbeat
      return true if get("/heartbeat").status == 200
      false
    rescue OpConnect::Error
      false
    end

    # Query the state of the server and its service dependencies.
    #
    # @return [ServerHealth] Returns a `ServerHealth` object.
    #
    def health
      ServerHealth.new get("/health").body
    end

    # Returns Prometheus metrics collected by the server.
    #
    # @return [String] Returns a plain text list of Prometheus metrics.
    #
    # @see https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format
    #   Prometheus documentation
    #
    def metrics
      get("/metrics").body
    end
  end
end
