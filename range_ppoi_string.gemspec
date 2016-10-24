# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'range_ppoi_string/version'

Gem::Specification.new do |spec|
  spec.name          = "range_ppoi_string"
  spec.version       = RangePpoiString::VERSION
  spec.licenses      = ["MIT"]
  spec.authors       = ["yancya"]
  spec.email         = ["yancya@upec.jp"]

  spec.summary       = %q{Handling range ppoi string}
  spec.description   = %q{Convert Array to range ppoi string, and reverse}
  spec.homepage      = %q{https://github.com/yancya/range_ppoi_string}

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", '~> 0'
end
