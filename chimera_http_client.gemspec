lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "chimera_http_client/version"

Gem::Specification.new do |spec|
  spec.name          = "chimera_http_client"
  spec.version       = ChimeraHttpClient::VERSION
  spec.authors       = ["Andreas Finger"]
  spec.email         = ["webmaster@mediafinger.com"]

  spec.summary       = "Http Client to connect to REST APIs"
  spec.description   = "General http client functionality to easily connect to JSON endpoints"
  spec.homepage      = "https://github.com/mediafinger/chimera_http_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # the only sub-dependencies
  spec.add_runtime_dependency "typhoeus", "~> 1.1"
  spec.add_runtime_dependency "zeitwerk", ">= 2.0"

  # general development and test dependencies
  spec.add_development_dependency "awesome_print",      "~> 1.8"
  spec.add_development_dependency "bundler",            ">= 1.0"
  spec.add_development_dependency "bundler-audit",      "~> 0.6"
  spec.add_development_dependency "irb",                "~> 1.0"
  spec.add_development_dependency "rake",               ">= 10.0"
  spec.add_development_dependency "rspec",              "~> 3.0"
  spec.add_development_dependency "rubocop",            "~> 0.50"
  spec.add_development_dependency "rubocop-rspec",      "~> 1.4"

  # only for server specs with real HTTP requests
  spec.add_development_dependency "capybara",           "~> 3.0"
  spec.add_development_dependency "capybara_discoball", "~> 0.1"
  spec.add_development_dependency "sinatra",            "~> 2.0"
  spec.add_development_dependency "sinatra-contrib",    "~> 2.0"
  spec.add_development_dependency "webmock",            "~> 3.0"
end
