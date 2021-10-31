module OpConnect
  class Item
    class Section
      attr_reader :id, :label

      def initialize(options = {})
        @id = options["id"]
        @label = options["label"]
      end
    end
  end
end
