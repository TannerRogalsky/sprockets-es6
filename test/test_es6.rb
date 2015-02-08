require 'minitest/autorun'
require 'sprockets'
require 'sprockets/es6'

class TestES6 < MiniTest::Test
  def setup
    @env = Sprockets::Environment.new
    @env.append_path File.expand_path("../fixtures", __FILE__)
  end

  def test_transform_arrow_function
    assert asset = @env["math.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
"use strict";

var square = function (n) {
  return n * n;
};
    JS
  end

  def test_common_modules
    register Sprockets::ES6.new('modules' => 'common')
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
"use strict";

require("foo");
    JS
  end

  def test_amd_modules
    register Sprockets::ES6.new('modules' => 'amd')
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
define(["exports", "foo"], function (exports, _foo) {
  "use strict";
});
    JS
  end

  def test_amd_modules_with_ids
    register Sprockets::ES6.new('modules' => 'amd', 'moduleIds' => true)
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
define("unknown", ["exports", "foo"], function (exports, _foo) {
  "use strict";
});
    JS
  end

  def test_system_modules
    register Sprockets::ES6.new('modules' => 'system')
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
System.register(["foo"], function (_export) {
  "use strict";

  return {
    setters: [function (_foo) {}],
    execute: function () {}
  };
});
    JS
  end

  def test_system_modules_with_ids
    register Sprockets::ES6.new('modules' => 'system', 'moduleIds' => true)
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
System.register("unknown", ["foo"], function (_export) {
  "use strict";

  return {
    setters: [function (_foo) {}],
    execute: function () {}
  };
});
    JS
  end

  def register(processor)
    @env.register_transformer 'text/ecmascript-6', 'application/javascript', processor
  end
end
