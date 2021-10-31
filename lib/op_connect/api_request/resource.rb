module OpConnect
  class APIRequest
    class Resource
      attr_reader :type, :vault, :item, :item_version

      def initialize(options = {})
        @type = options["type"]
        @vault = Object.new(options["vault"])
        @item = Object.new(options["item"])
        @item_version = options["item_version"]
      end
    end
  end
end
