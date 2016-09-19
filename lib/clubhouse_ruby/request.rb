require 'net/http'

module ClubhouseRuby
  class Request
    API_URL = "https://api.clubhouse.io/api/v1/".freeze
    METHODS = {
      get: "GET",
      update: "PUT",
      delete: "DELETE",
      list: "GET",
      create: "POST",
      search: "POST"
    }.freeze

    attr_accessor :method, :uri, :token, :params

    def initialize(path:, method:, token:, params:{})
      raise ArgumentError if path.nil? || token.nil?
      raise ArgumentError unless METHODS.include?(method)

      self.uri = API_URL + path.join('/')
      self.uri += params.delete[:id] if params.key?(:id)

      self.method = method
      self.token = token
      self.params = params
    end

    def request
      # execute the request
      # use https
      # wrap the response
      # decorate errors
      # return
    end
  end
end
