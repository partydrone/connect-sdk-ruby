module OpConnect
  class Client
    module Items
      # Get a list of items from a vault.
      #
      # @param vault_id [String] The vault UUID.
      # @param params [Hash] Query parameters.
      # @option params [String] :filter Optionally filter the item collection
      #   based on item title using SCIM-sytle filters.
      #
      # @example
      #   client.items(vault_id: vault.id, filter: 'title eq "foo"')
      #
      # @see https://ldapwiki.com/wiki/SCIM%20Filtering SCIM Filtering
      #
      # @return [<Type>] <description>
      #
      def list_items(vault_id:, **params)
        get("vaults/#{vault_id}/items", params: params).body.map { |item| Item.new(item) }
      end
      alias_method :items, :list_items

      def get_item(vault_id:, id:)
        Item.new get("vaults/#{vault_id}/items/#{id}").body
      end
      alias_method :item, :get_item

      def create_item(vault_id:, **attributes)
        Item.new post("vaults/#{vault_id}/items", body: attributes).body
      end

      def replace_item(vault_id:, id:, **attributes)
        Item.new put("vaults/#{vault_id}/items/#{id}", body: attributes).body
      end

      def delete_item(vault_id:, id:)
        return true if delete("vaults/#{vault_id}/items/#{id}").status == 204
        false
      rescue OpConnect::Error
        false
      end

      def update_item(vault_id:, id:, **attributes)
        Item.new patch("vaults/#{vault_id}/items/#{id}", body: attributes, headers: {"Content-Type": "applicatoin/json-patch+json"}).body
      end
    end
  end
end
