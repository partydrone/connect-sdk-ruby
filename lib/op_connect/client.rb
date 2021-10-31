module OpConnect
  class Client
    autoload :Vaults, "op_connect/client/vaults"
    autoload :Items, "op_connect/client/items"

    include OpConnect::Configurable
    include OpConnect::Connection
    include OpConnect::Client::Vaults
    include OpConnect::Client::Items

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

    def health
    end

    def heartbeat
      get("heartbeat")
    end
  end
end
