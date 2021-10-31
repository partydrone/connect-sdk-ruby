module OpConnect
  class Client
    module Files
      def list_files(vault_id:, item_id:, **params)
        get("vaults/#{vault_id}/items/#{item_id}/files", params: params).body.map { |file| Item::File.new(file) }
      end
      alias_method :files, :list_files

      def get_file(vault_id:, item_id:, id:, **params)
        Item::File.new get("vaults/#{vault_id}/items/#{item_id}/files/#{id}", params: params).body
      end
      alias_method :file, :get_file

      def get_file_content(vault_id:, item_id:, id:)
        get("vaults/#{vault_id}/items/#{item_id}/files/#{id}/content").body
      end
      alias_method :file_content, :get_file_content
    end
  end
end
