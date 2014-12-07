require '6to5'
require 'sprockets'
require 'sprockets/es6/version'

module Sprockets
  class ES6
    def self.call(input)
      data = input[:data]
      result = input[:cache].fetch(['ES6', VERSION, data]) do
        ES6to5.transform(data, sourceMap: true)
      end

      # TODO: result['map']
      result['code']
    end
  end

  append_path ES6to5::Source.root
  register_mime_type 'text/ecmascript-6', extensions: ['.es6'], charset: EncodingUtils::DETECT_UNICODE
  register_transformer 'text/ecmascript-6', 'application/javascript', ES6
  register_preprocessor 'text/ecmascript-6', DirectiveProcessor
end
