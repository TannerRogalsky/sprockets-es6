require 'minitest/autorun'
require 'sprockets'
require 'sprockets/es6'

class TestES6 < MiniTest::Test
  def setup
    Sprockets::ES6.babel_options.clear
    @env = Sprockets::Environment.new
    @env.append_path File.expand_path("../fixtures", __FILE__)
  end

  def test_transform_arrow_function
    assert asset = @env["math.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
"use strict";

var square = function square(n) {
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

  def test_babel_options
    Sprockets::ES6.babel_options['sourceMaps'] = 'both'
    register Sprockets::ES6.new('modules' => 'common')
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
"use strict";

require("foo");
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1vZC5lczYuZXJiIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7O1FBQU8sS0FBSyIsImZpbGUiOiJtb2QuZXM2LmVyYiIsInNvdXJjZVJvb3QiOiIvZGV2aG9tZS9tbTU4MzAvZ2l0L3Nwcm9ja2V0cy1lczYvdGVzdC9maXh0dXJlcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCBcImZvb1wiO1xuIl19
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
define("mod", ["exports", "foo"], function (exports, _foo) {
  "use strict";
});
    JS
  end

  def test_amd_modules_with_ids_and_root
    register Sprockets::ES6.new('modules' => 'amd', 'moduleIds' => true, 'moduleRoot' => 'root')
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
define("root/mod", ["exports", "foo"], function (exports, _foo) {
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
System.register("mod", ["foo"], function (_export) {
  "use strict";

  return {
    setters: [function (_foo) {}],
    execute: function () {}
  };
});
    JS
  end

  def test_system_modules_with_ids_and_root
    register Sprockets::ES6.new('modules' => 'system', 'moduleIds' => true, 'moduleRoot' => 'root')
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
System.register("root/mod", ["foo"], function (_export) {
  "use strict";

  return {
    setters: [function (_foo) {}],
    execute: function () {}
  };
});
    JS
  end

  def test_caching_takes_filename_into_account
    register Sprockets::ES6.new('modules' => 'system', 'moduleIds' => true, 'moduleRoot' => 'root')
    mod1 = @env["mod.js"]
    mod2 = @env["mod2.js"]
    assert_equal <<-JS.chomp, mod1.to_s.strip
System.register("root/mod", ["foo"], function (_export) {
  "use strict";

  return {
    setters: [function (_foo) {}],
    execute: function () {}
  };
});
    JS
    assert_equal <<-JS.chomp, mod2.to_s.strip
System.register("root/mod2", ["foo"], function (_export) {
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
