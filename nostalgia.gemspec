# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nostalgia/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Glenn Davy"]
  gem.email         = ["glenn@davy.net.au"]
  gem.description   = %q{Learn whats happening in your memcached}
  gem.summary       = %q{Learn whats happening in your memcached}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nostalgia"
  gem.require_paths = ["lib"]
  gem.version       = Nostalgia::VERSION
  gem.add_development_dependency("guard")
  gem.add_development_dependency("guard-minitest")
  gem.add_development_dependency("guard-bundler")
  gem.add_development_dependency("ruby_gntp")
  gem.add_development_dependency("debugger", ">=1.5")
  gem.add_development_dependency("rb-fsevent")
  gem.add_dependency("chronic_duration")
end
