require 'babel/transpiler'
require 'sprockets'
require 'sprockets/es6/version'

module Sprockets
  class ES6
    def self.instance
      @instance ||= new
    end

    def self.call(input)
      instance.call(input)
    end

    def initialize(options = {})
      @options = options.dup.freeze

      @cache_key = [
        self.class.name,
        Babel::Transpiler.version,
        Babel::Transpiler.source_version,
        VERSION,
        @options
      ].freeze
    end

    def call(input)
      data = input[:data]
      result = input[:cache].fetch(@cache_key + [data]) do
        opts = @options.merge(
          'sourceRoot' => input[:load_path],
          'moduleRoot' => nil,
          'filename' => input[:filename],
          'filenameRelative' => input[:environment].split_subpath(input[:load_path], input[:filename])
        )

        if opts['moduleIds']
          opts['moduleId'] ||= input[:name]
        end

        Babel::Transpiler.transform(data, opts)
      end
      result['code']
    end
  end

  append_path Babel::Transpiler.source_path
  register_mime_type 'text/ecmascript-6', extensions: ['.es6'], charset: :unicode
  register_transformer 'text/ecmascript-6', 'application/javascript', ES6
  register_preprocessor 'text/ecmascript-6', DirectiveProcessor
end
