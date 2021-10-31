module OpConnect
  class Item
    class Field
      attr_reader :purpose, :type, :value, :should_generate, :recipe, :section

      alias_method :generate?, :should_generate

      def initialize(options = {})
        @purpose = options["purpose"] if options["purpose"]
        @type = options["type"] if options["type"]
        @value = options["value"]
        @should_generate = options["generate"] || false
        @recipe = GeneratorRecipe.new(options["recipe"])
        @section = Object.new(options["section"])
      end
    end
  end
end
