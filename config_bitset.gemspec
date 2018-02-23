
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "config_bitset/version"

Gem::Specification.new do |spec|
  spec.name          = "config_bitset"
  spec.version       = ConfigBitset::VERSION
  spec.authors       = ["Masatoshi Nishiguchi"]
  spec.email         = ["nishiguchi.masa@gmail.com"]

  spec.summary       = "An abstract class that implements utility methods for managing config flags."

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop"
  spec.add_dependency "activesupport"
end
