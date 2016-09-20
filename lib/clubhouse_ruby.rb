require "clubhouse_ruby/version"
require "clubhouse_ruby/constants"
require "clubhouse_ruby/path_builder"
require "clubhouse_ruby/request"

module ClubhouseRuby
  class Clubhouse
    include PathBuilder

    attr_accessor :token, :response_format

    def initialize(token, response_format: :json)
      raise ArgumentError unless ClubhouseRuby::FORMATS.keys.include?(response_format)

      self.token = token
      self.response_format = response_format
    end
  end
end
