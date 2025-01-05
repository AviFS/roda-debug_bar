require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name        = 'roda-debug_bar'
  spec.version     = DebugBar::VERSION
  spec.authors     = ['Avi Feher Sternlieb']
  spec.email       = ['avifsternlieb@gmail.com']

  spec.summary     = 'A debug bar for Roda'
  spec.homepage    = 'https://github.com/avifs/roda-debug_bar'
  spec.license     = 'MIT'

  spec.add_dependency 'roda', '~> 3.87'
  spec.add_dependency 'tty-logger', '~> 0.3'
  spec.add_dependency 'pathname', '~> 0.4'
  spec.add_dependency 'rouge', '~> 4.5'
  spec.add_dependency 'json', '~> 2.9'
  spec.add_dependency 'sequel', '~> 5.88'
  spec.add_dependency 'logger', '~> 1.6'

  spec.required_ruby_version = '>= 2.1'

  spec.files = Dir['lib/**/*'] + Dir['public/*']
end
