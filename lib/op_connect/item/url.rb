module OpConnect
  class Item
    class URL
      attr_reader :url, :is_primary

      alias_method :primary?, :is_primary

      def initialize(options = {})
        @url = options["url"]
        @is_primary = options["primary"] || false
      end
    end
  end
end
