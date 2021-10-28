module OpConnect
  class Client
    include OpConnect::Configurable
    include OpConnect::Connection

    def initialize(options = {})
      OpConnect::Configurable.keys.each do |key|
        value = options.key?(key) ? options[key] : OpConnect.instance_variable_get(:"@#{key}")
        instance_variable_set(:"@#{key}", value)
      end
    end

    def inspect
      inspected = super
      inspected.gsub!(@access_token, "#{"*" * 24}") if @access_token
      inspected
    end

    def health
    end
  end
end
