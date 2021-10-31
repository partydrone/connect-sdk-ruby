module OpConnect
  class Item
    class File
      attr_reader :id, :name, :size, :content_path, :content, :section

      def initialize(options = {})
        @id = options["id"]
        @name = options["name"]
        @size = options["size"]
        @content_path = options["content_path"]
        @content = options["content"]
        @section = Object.new(options["section"])
      end
    end
  end
end
