# 1Password Connect Ruby SDK

![example workflow](https://github.com/partydrone/connect-sdk-ruby/actions/workflows/test.yml/badge.svg) [![Maintainability](https://api.codeclimate.com/v1/badges/e5d93bbb1ec1b779aada/maintainability)](https://codeclimate.com/github/partydrone/connect-sdk-ruby/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/e5d93bbb1ec1b779aada/test_coverage)](https://codeclimate.com/github/partydrone/connect-sdk-ruby/test_coverage) [![Gem Version](https://badge.fury.io/rb/op_connect.svg)](https://badge.fury.io/rb/op_connect)

<img width="1012" alt="op_connect_banner" src="https://user-images.githubusercontent.com/57892/139618110-63e92aa3-794a-463b-b72a-d6a5909a5b8a.png">

The 1Password Connect Ruby SDK provides access to the 1Password Connect API
hosted on your infrastructure. The gem is intended to be used by your
applications, pipelines, and other automations to simplify accessing items
stored in your 1Password vaults.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'op_connect'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install op_connect
```

## Configuration and Defaults

While `OpConnect::Client` accepts a range of options when creating a new client
instance, OpConnect's configuration API allows you to set your configuration
options at the module level. This is particularly handy if you're creating a
number of client instances based on some shared defaults. Changing options
affects new instances only and will not modify existing `OpConnect::Client`
instances created with previous options.

### Configuring module defaults

Every writable attribute in `OpConnect::Configurable` can be set one at a time:

```ruby
OpConnect.api_endpoint = "http://localhost:8080/v1"
OpConnect.access_token = "secret_access_token"
```

Or in a batch:

```ruby
OpConnect.configure do |config|
  config.api_endpoint = "http://localhost:8080/v1"
  config.access_token = "secret_access_token"
end
```

### Using ENV variables

Default configuration values are specified in `OpConnect::Default`. Many attributes look for a
default value from ENV before returning OpConnect's default.

| Variable                  | Description                                                                   | Default                                         |
| ------------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------- |
| `OP_CONNECT_ACCESS_TOKEN` | The API token used to authenticate the client to a 1Password Connect API.     |                                                 |
| `OP_CONNECT_API_ENDPOINT` | The URL of the 1Password Connect API server.                                  | <http://localhost:8080/v1>                      |
| `OP_CONNECT_USER_AGENT`   | The user-agent string the client uses when making requests. This is optional. | 1Password Connect Ruby SDK {OpConnect::VERSION} |

## Usage

### Making requests

API methods are available as client instance methods.

```ruby
# Provide an access token
client = OpConnect::Client.new(access_token: "secret_access_token")

# Fetch a list of vaults
client.vaults
```

### Using query parameters

You can pass query parameters to some GET-based requests.

```ruby
client.vaults filter: "title eq 'Secrets Automation'"
```

> 👀 For more information, see the [API documentation][api_docs].

### Consuming resources

Most methods return an object which provides convenient dot notation for fields
returned in the API response.

#### List vaults

```ruby
vaults = client.vaults
# => [#<OpConnect::Vault:0x00007fae27198610 …
vaults.first.id
# => "alynbizzypgx62nti6zxajloei"
```

#### Get vault details

```ruby
vault = client.vault(id: "alynbizzypgx62nti6zxajloei")
# => #<OpConnect::Vault:0x00007fae200c1a18 …
```

#### List items

```ruby
items = client.items(vault_id: vault.id)
# => [#<OpConnect::Item:0x00007fae27151490 …
```

#### Add item

The request must include a `FullItem` object containing the information to
create the item.

> 👀 See the [API documentation](https://support.1password.com/connect-api-reference/#add-an-item)
> for an example.

```ruby
attributes = {
  vault: {
    id: vault.id
  },
  title: "Secrets Automation Item",
  category: "LOGIN",
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
        characterSets: ["LETTERS", "DIGITS"]
      }
    }
  ]
  # …
}

item = client.create_item(vault_id: vault.id, body: attributes)
# => #<OpConnect::Item:0x00007fae27151490 …
```

#### Get item details

```ruby
item = client.item(vault_id: vault.id, id: "yqthoh76cfzpbsimk6zixshosq")
# => #<OpConnect::Item:0x00007fae27151490 …
item.title
# => "AWS IAM Account"
item.favorite?
# => false
```

#### Replace an item

```ruby
attributes = {
  vault: {
    id: vault.id
  },
  title: "Secrets Automation Item",
  category: "LOGIN",
  fields: [
    {
      value: "jonathan",
      purpose: "USERNAME"
    },
    {
      purpose: "PASSWORD",
      generate: true,
      recipe: {
        length: 55,
        characterSets: ["LETTERS", "DIGITS"]
      }
    }
  ]
  # …
}

item = client.replace_item(vault_id: vault.id, id: item.id, body: attributes)
# => #<OpConnect::Item:0x00007fae27151490 …
```

> 👀 See the [API documentation](https://support.1password.com/connect-api-reference/#add-an-item)
> for an explanation and list of fields and object structure.

#### Change item details

Use the [JSON Patch](https://tools.ietf.org/html/rfc6902) document standard to
compile a series of operations to make more targeted changes to an item.

> 👀 See the [API documentation](https://support.1password.com/connect-api-reference/#change-item-details)
> for more information.

```ruby
attributes = [
  {op: "replace", path: "/title", value: "New Secrets Automation Item"},
  {op: "replace", path: "/fields/username", value: "tinkerbell"}
]

item = client.update_item(vault_id: vault.id, id: item.id, body: attributes)
# => #<OpConnect::Item:0x00007fae27151490 …
```

#### Delete an item

```ruby
client.delete_item(vault_id: vault.id, id: item.id)
# => true
```

#### List files

```ruby
files = client.files(vault_id: vault.id, item_id: item.id)
# => [#<OpConnect::Item::File:0x00007fae27151490 …
```

#### Get file details

```ruby
file = client.file(vault_id: vault.id, item_id: item.id, id: "6r65pjq33banznomn7q22sj44e")
# => #<OpConnect::Item::File:0x00007fae27151490 …
```

#### Get file content

```ruby
content = client.file(vault_id: vault.id, item_id: item.id, id: file.id)
# => "The future belongs to the curious.\n"
```

#### List API activity

Retrieve a list of API requests made to the server.

```ruby
client.activity
# => [#<OpConnect::APIRequest:0x00007fae27151490 …
```

#### Check server for a heartbeat

Ping the server to check if it's active or not.

```ruby
client.heartbeat
# => true
```

#### Get server health info

Query the state of the server and its service dependencies.

```ruby
client.health
# => #<OpConnect::ServerHealth:0x00007fae27151490 …
```

#### Get server metrics

This returns Prometheus metrics collected by the server.

```ruby
client.metrics
# => "# HELP go_gc_duration_seconds A summary of the pause duration of …
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Running a local 1Password Connect API server

This project includes a docker-compose.yml file that will download and run an
API and Sync server for you to test with locally. You will need to:

- [ ] Install Docker, Docker for Mac, or Docker for Windows.
- [ ] Place your 1password-credentials.json file in the root of this project.

> 👀 See [Get started with a 1Password Secrets Automation workflow][secrets_automation_workflow]
> for more information.

### Resources

Some links that are definitely worth checking out:

- [1Password Secrets Automation](https://1password.com/secrets/)
- [Get started with a 1Password Secrets Automation workflow][secrets_automation_workflow]
- [1Password Connect API reference][api_docs]

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/partydrone/connect-sdk-ruby>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/partydrone/connect/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Connect project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/partydrone/connect/blob/main/CODE_OF_CONDUCT.md).

[api_docs]: https://support.1password.com/connect-api-reference '1Password Connect API reference'
[secrets_automation_workflow]: https://support.1password.com/secrets-automation/ 'Get started with a 1Password Secrets Automation workflow'
