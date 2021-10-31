module OpConnect
  class Vault
    attr_reader :id, :name, :attribute_version, :content_version, :items, :type, :created_at, :updated_at

    def initialize(options = {})
      @id = options["id"]
      @name = options["name"]
      @attribute_version = options["attributeVersion"]
      @content_version = options["contentVersion"]
      @items = options["items"]
      @type = options["type"]
      @created_at = options["createdAt"]
      @updated_at = options["updatedAt"]
    end
  end
end
