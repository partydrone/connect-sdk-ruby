module OpConnect
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

    def inspect
      inspected = super
      inspected.gsub!(@access_token, ("*" * 24).to_s) if @access_token
      inspected
    end

    def activity(**params)
      get("activity", params: params).body.map { |a| APIRequest.new(a) }
    end

    def heartbeat
      return true if get("/heartbeat").status == 200
      false
    rescue OpConnect::Error
      false
    end

    def health
      ServerHealth.new get("/health").body
    end

    def metrics
      get("/metrics").body
    end
  end
end
