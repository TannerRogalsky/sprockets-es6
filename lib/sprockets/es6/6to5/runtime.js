(function () {
  var self = typeof global === "undefined" ? window : global;
  var to5Runtime = self.to5Runtime = {};
  to5Runtime.extends = function (child, parent) {
    child.prototype = Object.create(parent.prototype, {
      constructor: {
        value: child,
        enumerable: false,
        writable: true,
        configurable: true
      }
    });
    child.__proto__ = parent;
  };
  to5Runtime.classProps = function (child, staticProps, instanceProps) {
    if (staticProps) Object.defineProperties(child, staticProps);
    if (instanceProps) Object.defineProperties(child.prototype, instanceProps);
  };
  to5Runtime.slice = Array.prototype.slice;
  to5Runtime.applyConstructor = function (Constructor, args) {
    var bindArgs = [null].concat(args);

    var Factory = Constructor.bind.apply(Constructor, bindArgs);

    return new Factory();
  };
  to5Runtime.taggedTemplateLiteral = function (strings, raw) {
    return Object.defineProperties(strings, {
      raw: {
        value: raw
      }
    });
  };
})();
