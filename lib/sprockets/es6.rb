require 'execjs'
require 'sprockets'

module Sprockets
  class ES6
    VERSION = '0.1.0'

    def self.context
      @context ||= begin
        js = <<-JS
          #{File.read(File.expand_path("../es6/6to5.js", __FILE__))}

          function _transform() {
            var result = to5.transform.apply(this, arguments);
            return { code: result.code, map: result.map };
          }
        JS
        ExecJS.compile(js)
      end
    end

    def self.transform(code, options = {})
      context.call('_transform', code, options)
    end

    def self.call(input)
      data = input[:data]
      result = input[:cache].fetch(['ES6', VERSION, data]) do
        transform(data, sourceMap: true)
      end

      # TODO: result['map']
      result['code']
    end
  end

  append_path File.expand_path("../es6", __FILE__)
  register_mime_type 'text/ecmascript-6', extensions: ['.es6'], charset: EncodingUtils::DETECT_UNICODE
  register_transformer 'text/ecmascript-6', 'application/javascript', ES6
  register_preprocessor 'text/ecmascript-6', DirectiveProcessor
end
