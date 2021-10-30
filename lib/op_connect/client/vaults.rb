module OpConnect
  class Client
    module Vaults
      def list_vaults(**params)
        get("vaults", params: params).body.map { |vault| Vault.new(vault) }
      end
      alias_method :vaults, :list_vaults

      def get_vault(id)
        Vault.new get("vaults/#{id}").body
      end
      alias_method :vault, :get_vault
    end
  end
end
