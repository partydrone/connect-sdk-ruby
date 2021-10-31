require "test_helper"

describe OpConnect::Client::Files do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:client) { OpConnect::Client.new(access_token: "fake", adapter: :test, stubs: stubs) }

  describe "list_files" do
    it "returns a list of files for an item" do
      stubs.get("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items/2fcbqwe9ndg175zg2dzwftvkpa/files") { [200, {"Content-Type": "application/json"}, fixture("files/list.json")] }

      _(client.files(
        vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz",
        item_id: "2fcbqwe9ndg175zg2dzwftvkpa"
      ).first).must_be_instance_of OpConnect::File
    end
  end

  describe "get_file" do
    it "returns a file object" do
      stubs.get("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items/2fcbqwe9ndg175zg2dzwftvkpa/files/6r65pjq33banznomn7q22sj44e") { [200, {"Content-Type": "application/json"}, fixture("files/get.json")] }

      file = client.file(
        vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz",
        item_id: "2fcbqwe9ndg175zg2dzwftvkpa",
        id: "6r65pjq33banznomn7q22sj44e"
      )

      _(file).must_be_instance_of OpConnect::File
      _(file.id).must_equal "6r65pjq33banznomn7q22sj44e"
      _(file.name).must_equal "testfile.txt"
    end
  end

  describe "get_file_content" do
    it "returns the contents of a file" do
      stubs.get("/v1/vaults/ftz4pm2xxwmwrsd7rjqn7grzfz/items/2fcbqwe9ndg175zg2dzwftvkpa/files/6r65pjq33banznomn7q22sj44e/content") { [200, {}, fixture("files/testfile.txt")] }

      content = client.file_content(
        vault_id: "ftz4pm2xxwmwrsd7rjqn7grzfz",
        item_id: "2fcbqwe9ndg175zg2dzwftvkpa",
        id: "6r65pjq33banznomn7q22sj44e"
      )

      _(content).must_equal "The future belongs to the curious.\n"
    end
  end
end
