module OpConnect
  module Configurable
    attr_accessor :access_token, :adapter, :stubs, :user_agent
    attr_writer :api_endpoint

    class << self
      def keys
        @keys ||= [
          :access_token,
          :adapter,
          :api_endpoint,
          :stubs,
          :user_agent
        ]
      end
    end

    def configure
      yield self
    end

    def reset!
      OpConnect::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", OpConnect::Default.options[key])
      end

      self
    end
    alias_method :setup, :reset!

    def same_options?(opts)
      opts.hash == options.hash
    end

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    private

    def options
      OpConnect::Configurable.keys.map { |key| [key, instance_variable_get(:"@#{key}")] }.to_h
    end
  end
end
