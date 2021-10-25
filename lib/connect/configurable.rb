module Connect
  module Configurable
    attr_accessor :access_token, :adapter, :api_endpoint, :stubs, :user_agent

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

      def configure
        yield self
      end

      def reset!
        Connect::Configurable.keys.each do |key|
          instance_variable_set(:"@#{key}", Connect::Default.options[key])
        end

        self
      end
      alias_method :setup, :reset!

      def same_options?(opts)
        opts.hash == options.hash
      end

      private

      def options
        Connect::Configurable.keys.map { |key| [key, instance_variable_get(:"@#{key}")] }.to_h
      end
    end
  end
end
