# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metador/version'

Gem::Specification.new do |spec|
  spec.name          = "metador"
  spec.version       = Metador::VERSION
  spec.authors       = ["Piotr Gaertig"]
  spec.email         = ["github@gaertig.pl"]
  spec.description   = %q{Thumbnailer and metadata extractor as a service}
  spec.summary       = %q{Thumbnails and extracts metadata from images, videos, documents etc. List of supported extensions is expected to grow. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["metador-cli", "metador-worker"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.4.2"
  spec.add_development_dependency "json"
  spec.add_development_dependency "guard-minitest"
end
