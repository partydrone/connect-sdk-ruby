# frozen_string_literal: true

require "simplecov"
require "simplecov-lcov"
require "simplecov-tailwindcss"

SimpleCov.start do
  add_filter "/test/"
  coverage_dir "test/coverage"

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::LcovFormatter,
    SimpleCov::Formatter::TailwindFormatter
  ])

  add_group "Models", "lib/connect/objects/"
  add_group "Resources", "lib/connect/client/"
  add_group "Middleware", ["lib/connect/request/", "lib/connect/response/", "lib/connect/middleware/"]
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "op_connect"
require "minitest/autorun"
require "minitest/reporters"
require "faraday"
require "json"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)
