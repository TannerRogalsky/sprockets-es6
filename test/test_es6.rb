require 'minitest/autorun'
require 'sprockets'
require 'sprockets/es6'

class TestES6 < MiniTest::Test
  def setup
    @env = Sprockets::Environment.new
    @env.append_path File.expand_path("../fixtures", __FILE__)
  end

  def test_require_asset
    assert asset = @env["require_asset"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
"use strict";

var square = function square(n) {
  return n * n;
};
    JS
  end

  def test_require_asset_from_es6
    assert asset = @env["es6_require"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
function square(n) {
  return n * n;
};
"use strict";

var x = 10;
    JS
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

  def test_class_level_transformation_configuration
    Sprockets::ES6.configure do |config|
      config.modules = 'amd'
      config.moduleIds = true
    end
    processor = Sprockets::ES6.new

    mock_env = OpenStruct.new
    def mock_env.split_subpath(*args)
      nil
    end

    transformation_options = processor.transformation_options(
      :environment => mock_env
    )
    assert_equal transformation_options['modules'], 'amd'
    assert transformation_options['moduleIds']
    Sprockets::ES6.reset_configuration
  end

  def register(processor)
    @env.register_engine '.es6', processor, mime_type: 'application/javascript'
  end
end
