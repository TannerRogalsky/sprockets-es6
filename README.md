# Sprockets ES6

A Sprockets transformer that converts ES6 code into vanilla ES5 with [6to5](https://6to5.github.io).

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

## Caveats

Requires Sprockets 3 betas.
