require "shortcut_ruby/version"
require "shortcut_ruby/constants"
require "shortcut_ruby/path_builder"
require "shortcut_ruby/request"

module ShortcutRuby
  class Shortcut
    include PathBuilder

    attr_accessor :token, :response_format

    # This is the basic object to interact with the shortcut api. An api token
    # is required, and optionally the response format can be set.
    #
    def initialize(token, response_format: :json)
      raise ArgumentError unless input_valid?(token, response_format)

      self.token = token
      self.response_format = response_format
    end

    private

    def input_valid?(token, response_format)
      !token.nil? && FORMATS.keys.include?(response_format)
    end
  end
end
