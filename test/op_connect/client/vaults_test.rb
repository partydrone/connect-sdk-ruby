require "test_helper"

describe OpConnect::Client::Vaults do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:client) { OpConnect::Client.new(access_token: "fake", adapter: :test, stubs: stubs) }

  describe "list_vaults" do
    it "returns a list of vaults" do
      stubs.get("/v1/vaults") { [200, {"Content-Type": "application/json"}, fixture("vaults/list.json")] }

      _(client.vaults.first).must_be_instance_of OpConnect::Vault
    end
  end

  describe "get_vault" do
    it "returns a valut" do
      stubs.get("/v1/vaults/ytrfte14kw1uex5txaore1emkz") { [200, {"Content-Type": "application/json"}, fixture("vaults/get.json")] }

      vault = client.vault(id: "ytrfte14kw1uex5txaore1emkz")

      _(vault).must_be_instance_of OpConnect::Vault
      _(vault.id).must_equal "ytrfte14kw1uex5txaore1emkz"
    end
  end
end
