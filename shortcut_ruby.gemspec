lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shortcut_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'shortcut_ruby'
  spec.version       = ShortcutRuby::VERSION
  spec.authors       = ['Michael Carey', 'Jake Sorce']
  spec.email         = ['engineering@doubleloop.app']

  spec.summary       = 'A lightweight Ruby wrapper for the Shortcut REST API.'
  spec.homepage      = 'https://github.com/doubleloopapp/shortcut_ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'dotenv', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.7'
end
