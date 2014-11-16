require 'sprockets/es6'

Gem::Specification.new do |s|
  s.name    = 'sprockets-es6'
  s.version = Sprockets::ES6::VERSION

  s.homepage    = "http://github.com/josh/sprockets-es6"
  s.summary     = "Sprockets ES6 transformer"
  s.description = <<-EOS
    A Sprockets transformer that converts ES6 code into vanilla ES5 with 6to5.
  EOS
  s.license = "MIT"

  s.files = [
    'lib/sprockets/es6.rb',
    'lib/sprockets/es6/6to5.js',
    'lib/sprockets/es6/6to5/polyfill.js',
    'lib/sprockets/es6/6to5/runtime.js',
    'LICENSE',
    'README.md'
  ]

  s.add_dependency 'execjs', '~> 2.0'
  s.add_dependency 'sprockets', '3.0.0.beta.3'
  s.add_development_dependency 'rake'

  s.authors = ['Joshua Peek']
  s.email   = 'josh@joshpeek.com'
end
