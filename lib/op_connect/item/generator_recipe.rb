module OpConnect
  class Item
    class GeneratorRecipe
      attr_reader :length, :character_sets

      def initialize(options = {})
        @length = options["length"] if options & ["length"]
        @character_sets = options["characterSets"] if options & ["characterSets"]
      end
    end
  end
end
