# frozen_string_literal: true

$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), "lib"))
require "Mailclerk"

Gem::Specification.new do |spec|
  spec.name = Mailclerk::Identity.name
  spec.version = Mailclerk::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Noah Litvin", "Greg Sherri"]
  spec.email = ["developers@mailclerk.app"]
  spec.homepage = "https://github.com/mailclerk/mailclerk-ruby"
  spec.summary = "Official Mailclerk ruby gem"
  spec.license = "MIT"

  spec.metadata = {
    # "source_code_uri" => "",
    # "changelog_uri" => "/blob/master/CHANGES.md",
    # "bug_tracker_uri" => "/issues"
  }


  spec.required_ruby_version = "~> 2.5"

  spec.add_runtime_dependency 'faraday'

  spec.add_development_dependency "bundler-audit", "~> 0.6"
  spec.add_development_dependency "gemsmith", "~> 14.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths = ["lib"]
end
