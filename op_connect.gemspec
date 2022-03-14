# frozen_string_literal: true

require_relative "lib/op_connect/version"

Gem::Specification.new do |spec|
  spec.name = "op_connect"
  spec.version = OpConnect::VERSION
  spec.authors = ["Andrew Porter"]
  spec.email = ["partydrone@icloud.com"]

  spec.summary = "A Ruby SDK for the 1Password Connect API."
  spec.description = "A Ruby SDK for the 1Password Connect API."
  spec.homepage = "https://github.com/partydrone/connect-sdk-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/partydrone/connect-sdk-ruby"
  spec.metadata["github_repo"] = "ssh://github.com/partydrone/connect-sdk-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.8"
  spec.add_dependency "faraday_middleware", "~> 1.2"
end
