require "test_helper"

describe "OpConnect::Client::Vaults" do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:client) { OpConnect::Client.new(access_token: "fake", adapter: :test, stubs: stubs) }

  describe "list_vaults" do
    it "returns a list of vaults" do
      stubs.get("/v1/vaults") do
        [
          200,
          {},
          [
            {
              id: "ytrfte14kw1uex5txaore1emkz",
              name: "Demo",
              attributeVersion: 1,
              contentVersion: 72,
              items: 7,
              type: "USER_CREATED",
              createdAt: "2021-04-10T17:34:26Z",
              updatedAt: "2021-04-13T14:33:50Z"
            }
          ]
        ]
      end

      _(client.vaults.first).must_be_instance_of OpConnect::Vault
    end
  end

  describe "get_vault" do
    it "returns a valut" do
      stubs.get("/v1/vaults/ytrfte14kw1uex5txaore1emkz") do
        [
          200,
          {},
          {
            id: "ytrfte14kw1uex5txaore1emkz",
            name: "Demo",
            attributeVersion: 1,
            contentVersion: 72,
            items: 7,
            type: "USER_CREATED",
            createdAt: "2021-04-10T17:34:26Z",
            updatedAt: "2021-04-13T14:33:50Z"
          }
        ]
      end

      _(client.vault("ytrfte14kw1uex5txaore1emkz")).must_be_instance_of OpConnect::Vault
      _(client.vault("ytrfte14kw1uex5txaore1emkz").id).must_equal "ytrfte14kw1uex5txaore1emkz"
    end
  end
end
