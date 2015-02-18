# Sprockets ES6

A Sprockets transformer that converts ES6 code into vanilla ES5 with [Babel JS](https://babeljs.io).

## Usage

``` ruby
# Gemfile
gem 'sprockets'
gem 'sprockets-es6'
```


``` ruby
require 'sprockets/es6'
```

``` js
// app.es6

square = (x) => x * x

class Animal {
  constructor(name) {
    this.name = name
  }
}
```

## Releases

This plugin is primarily experimental and will never reach a stable 1.0. The
purpose is to test out BabelJS features on Sprockets 3.x and include it by default
in Sprockets 4.x.

## Caveats

Requires Sprockets 3 betas.

``` ruby
gem 'sprockets', '~>3.0.0.beta'
```
