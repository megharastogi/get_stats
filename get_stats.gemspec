# -*- encoding: utf-8 -*-
require File.expand_path('../lib/get_stats/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["megha"]
  gem.email         = ["meghagulati30@gmail.com"]
  gem.description   = %q{Dead simply statistics for Rails.}
  gem.summary       = %q{Provides a simple API for developers to log & view stats within their app. Uses highcharts.js for displaying beautiful graphs with one simple call.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "get_stats"
  gem.require_paths = ["lib"]
  gem.version       = GetStats::VERSION
end

