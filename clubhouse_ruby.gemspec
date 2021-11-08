lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clubhouse_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'clubhouse_ruby'
  spec.version       = ClubhouseRuby::VERSION
  spec.authors       = ['Jake Sorce']
  spec.email         = ['jakesorce@gmail.com']

  spec.summary       = 'A lightweight Ruby wrapper for the Clubhouse REST API.'
  spec.homepage      = 'https://github.com/PhilipCastiglione/clubhouse_ruby'
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
