require "test_helper"

describe OpConnect::Client::Items do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:client) { OpConnect::Client.new(access_token: "fake", adapter: :test, stubs: stubs) }

  describe "list_items" do
    it "returns a list of items for a vault" do
      stubs.get("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items") { [200, {"Content-Type": "application/json"}, fixture("items/list.json")] }

      _(client.items(vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz").first).must_be_instance_of OpConnect::Item
    end
  end

  describe "get_item" do
    it "returns an item for a vault" do
      stubs.get("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items/2fcbqwe9ndg175zg2dzwftvkpa") { [200, {"Content-Type": "application/json"}, fixture("items/get.json")] }

      item = client.item(vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz", id: "2fcbqwe9ndg175zg2dzwftvkpa")

      _(item).must_be_instance_of OpConnect::Item
      _(item.vault.id).must_equal "ftz4pm2xxwmwrsd7rjqn7grzfz"
      _(item.id).must_equal "2fcbqwe9ndg175zg2dzwftvkpa"
    end
  end

  describe "create_item" do
    it "creates a new item" do
      body = {
        vault: {
          id: "ftz4pm2xxwmwrsd7rjqn7grzfz"
        },
        title: "Secrets Automation Item",
        category: "LOGIN",
        tags: [
          "connect",
          "\\ud83d\\udc27"
        ],
        sections: [
          {
            label: "Security Questions",
            id: "95cdbc3b-7742-47ec-9056-44d6af82d562"
          }
        ],
        fields: [
          {
            value: "wendy",
            purpose: "USERNAME"
          },
          {
            purpose: "PASSWORD",
            generate: true,
            recipe: {
              length: 55,
              characterSets: [
                "LETTERS",
                "DIGITS"
              ]
            }
          },
          {
            section: {
              id: "95cdbc3b-7742-47ec-9056-44d6af82d562"
            },
            type: "CONCEALED",
            generate: true,
            label: "Recovery Key"
          },
          {
            section: {
              id: "95cdbc3b-7742-47ec-9056-44d6af82d562"
            },
            type: "STRING",
            generate: true,
            label: "Random Text"
          },
          {
            type: "URL",
            label: "Example",
            value: "https://example.com"
          }
        ]
      }

      stubs.post("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items") { [200, {"Content-Type": "application/json"}, fixture("items/create.json")] }

      item = client.create_item(vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz", body: body)

      _(item).must_be_instance_of OpConnect::Item
      _(item.id).must_equal "2fcbqwe9ndg175zg2dzwftvkpa"
    end
  end

  describe "replace_item" do
    it "replaces an item with a new item" do
      body = {
        vault: {
          id: "ftz4pm2xxwmwrsd7rjqn7grzfz"
        },
        title: "New Secrets Automation Item",
        category: "LOGIN",
        tags: [
          "connect",
          "\\ud83d\\udc27"
        ],
        sections: [
          {
            label: "Security Questions",
            id: "95cdbc3b-7742-47ec-9056-44d6af82d562"
          }
        ],
        fields: [
          {
            value: "tinkerbell",
            purpose: "USERNAME"
          },
          {
            purpose: "PASSWORD",
            generate: true,
            recipe: {
              length: 55,
              characterSets: [
                "LETTERS",
                "DIGITS"
              ]
            }
          },
          {
            section: {
              id: "95cdbc3b-7742-47ec-9056-44d6af82d562"
            },
            type: "CONCEALED",
            generate: true,
            label: "Recovery Key"
          },
          {
            section: {
              id: "95cdbc3b-7742-47ec-9056-44d6af82d562"
            },
            type: "STRING",
            generate: true,
            label: "Random Text"
          },
          {
            type: "URL",
            label: "Example",
            value: "https://example.com"
          }
        ]
      }

      stubs.put("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items/2fcbqwe9ndg175zg2dzwftvkpa") { [200, {"Content-Type": "application/json"}, fixture("items/replace.json")] }

      item = client.replace_item(vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz", id: "2fcbqwe9ndg175zg2dzwftvkpa", body: body)

      _(item).must_be_instance_of OpConnect::Item
      _(item.id).must_equal "2fcbqwe9ndg175zg2dzwftvkpa"
    end
  end

  describe "delete_item" do
    it "deletes an item" do
      stubs.delete("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items/2fcbqwe9ndg175zg2dzwftvkpa") { [204, {}, ""] }

      _(client.delete_item(vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz", id: "2fcbqwe9ndg175zg2dzwftvkpa").status).must_equal 204
    end
  end

  describe "update_item" do
    it "updates an item" do
      attributes = [
        {op: "replace", path: "/title", value: "New Secrets Automation Item"},
        {op: "replace", path: "/fields/username", value: "tinkerbell"}
      ]

      stubs.patch("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items/2fcbqwe9ndg175zg2dzwftvkpa") { [200, {"Content-Type": "application/json"}, fixture("items/update.json")] }

      item = client.update_item(vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz", id: "2fcbqwe9ndg175zg2dzwftvkpa", attributes: attributes)

      _(item).must_be_instance_of OpConnect::Item
      _(item.title).must_equal "Updated Secrets Automation Item"
      _(item.fields[0].value).must_equal "tinkerbell"
    end
  end
end
