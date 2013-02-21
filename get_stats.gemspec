# -*- encoding: utf-8 -*-
require File.expand_path('../lib/get_stats/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["megha"]
  gem.email         = ["meghagulati30@gmail.com"]
  gem.description   = %q{In app staticts analysis}
  gem.summary       = %q{Provides tools to Ruby and Rails developers to perform staticts analysis with in there application.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "get_stats"
  gem.require_paths = ["lib"]
  gem.version       = GetStats::VERSION
end

