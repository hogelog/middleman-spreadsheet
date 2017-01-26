# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman/spreadsheet/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-spreadsheet"
  spec.version       = Middleman::Spreadsheet::VERSION
  spec.authors       = ["hogelog"]
  spec.email         = ["konbu.komuro@gmail.com"]

  spec.summary       = %q{Middleman extension for using Google spreadsheet as data files.}
  spec.homepage      = "https://github.com/hogelog/sheet_wrap"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sheet_wrap", ">= 0.1.1"
  spec.add_runtime_dependency "middleman-core", ">= 4.2.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
