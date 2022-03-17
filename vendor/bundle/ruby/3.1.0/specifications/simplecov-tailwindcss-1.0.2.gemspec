# -*- encoding: utf-8 -*-
# stub: simplecov-tailwindcss 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "simplecov-tailwindcss".freeze
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/chiefpansancolt/simplecov-tailwindcss/issues", "changelog_uri" => "https://github.com/chiefpansancolt/simplecov-tailwindcss/blob/master/CHANGELOG.md", "homepage_uri" => "https://chiefpansancolt.live/docs/simplecov_tailwind/", "source_code_uri" => "https://github.com/chiefpansancolt/simplecov-tailwindcss" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Christopher Pezza".freeze]
  s.date = "2020-11-27"
  s.description = "HTML Tailwind Design View of Simplecov as a formatterthat is clean, easy to read.".freeze
  s.email = ["chiefpansancolt@gmail.com".freeze]
  s.executables = ["console".freeze, "publish".freeze, "setup".freeze]
  s.files = ["bin/console".freeze, "bin/publish".freeze, "bin/setup".freeze]
  s.homepage = "https://chiefpansancolt.live/docs/simplecov_tailwind/".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.3.7".freeze
  s.summary = "HTML Tailwind Design View for Simplecov formatter".freeze

  s.installed_by_version = "3.3.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<simplecov>.freeze, ["~> 0.16"])
  else
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
  end
end
