$:.unshift File.expand_path("../lib", __FILE__)
require 'sprockets/es6/version'

Gem::Specification.new do |s|
  s.name    = 'sprockets-es6'
  s.version = Sprockets::ES6::VERSION

  s.homepage    = "https://github.com/TannerRogalsky/sprockets-es6"
  s.summary     = "Sprockets ES6 transformer"
  s.description = <<-EOS
    A Sprockets transformer that converts ES6 code into vanilla ES5 with Babel JS.
  EOS
  s.license = "MIT"

  s.files = [
    'lib/sprockets/es6.rb',
    'lib/sprockets/es6/version.rb',
    'LICENSE',
    'README.md'
  ]

  s.add_dependency 'babel-transpiler'
  s.add_dependency 'babel-source', '>= 5.8.11'
  s.add_dependency 'sprockets', '>= 3.0.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'

  s.authors = ['Joshua Peek']
  s.email   = 'josh@joshpeek.com'
end
