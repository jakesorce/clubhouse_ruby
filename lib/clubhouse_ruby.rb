require "clubhouse_ruby/version"
require "clubhouse_ruby/request"

module ClubhouseRuby
  class Clubhouse
    RESPONSE_FORMATS = ["application/json", "text/csv"].freeze

    attr_accessor :token, :response_format

    def initialize(token, response_format: "application/json")
      raise ArgumentError unless RESPONSE_FORMATS.include?(response_format)

      self.token = token
      self.response_format = response_format
    end
  end
end
