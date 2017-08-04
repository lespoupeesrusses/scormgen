# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scormgen/version"

Gem::Specification.new do |spec|
  spec.name          = "SCORMgen"
  spec.version       = Scormgen::VERSION
  spec.authors       = ["Arnaud Levy"]
  spec.email         = ["contact@arnaudlevy.com"]

  spec.summary       = 'Easy SCORM manifest generation'
  spec.homepage      = 'https://github.com/semiodesign/scormgen'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rubyzip"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end