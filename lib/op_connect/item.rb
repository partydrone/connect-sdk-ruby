module OpConnect
  class Item
    autoload :Field, "op_connect/item/field"
    autoload :File, "op_connect/item/file"
    autoload :GeneratorRecipe, "op_connect/item/generator_recipe"
    autoload :Section, "op_connect/item/section"
    autoload :URL, "op_connect/item/url"

    attr_reader :id, :title, :vault, :category, :urls, :is_favorite, :tags, :version, :state, :sections, :fields, :files, :created_at, :updated_at, :last_edited_by

    alias_method :favorite?, :is_favorite

    def initialize(options = {})
      @id = options["id"]
      @title = options["title"]
      @vault = Object.new(options["vault"])
      @category = options["category"]
      @urls = options["urls"]&.collect! { |url| URL.new(url) }
      @is_favorite = options["favorite"] || false
      @tags = options["tags"]
      @version = options["version"]
      @state = options["state"]
      @sections = options["sections"]&.collect! { |section| Section.new(section) }
      @fields = options["fields"]&.collect! { |field| Field.new(field) }
      @files = options["files"]&.collect! { |file| File.new(file) }
      @created_at = options["createdAt"]
      @updated_at = options["updatedAt"]
      @last_edited_by = options["lastEditedBy"]
    end
  end
end
