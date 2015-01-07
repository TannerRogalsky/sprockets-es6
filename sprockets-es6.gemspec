$:.push File.expand_path("../lib", __FILE__)

require 'sprockets/es6/version'

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
    'LICENSE',
    'README.md'
  ]

  s.add_dependency '6to5'
  s.add_dependency 'sprockets', '~> 3.0.0.beta'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'

  s.authors = ['Joshua Peek']
  s.email   = 'josh@joshpeek.com'
end
