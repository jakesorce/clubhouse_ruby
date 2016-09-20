require 'net/http'
require 'json'

module ClubhouseRuby
  class Request
    attr_accessor :uri, :method, :response_format, :params

    def initialize(call_object, method:, params: {})
      raise ArgumentError unless validate_input(call_object, method, params)

      self.params = params || {}
      self.uri = construct_uri(call_object)
      self.method = method
      self.response_format = call_object.response_format
    end

    def fetch
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |https|
        req = Net::HTTP.const_get(method).new(uri)

        set_body(req)
        set_format_header(req)

        wrap_response(https.request(req))
      end
    end

    private

    def validate_input(call_object, method, params)
      !call_object.nil? &&
        !call_object.path.nil? &&
        !call_object.token.nil? &&
        !call_object.response_format.nil? &&
        ClubhouseRuby::METHODS.values.include?(method) &&
        (params.is_a?(Hash) || params.nil?)
    end

    def construct_uri(call_object)
      base_url = ClubhouseRuby::API_URL
      path = call_object.path.map(&:to_s).map { |p| p.gsub('_', '-') }.join('/')
      object_id = self.params.delete(:id).to_s
      auth = "?token=#{call_object.token}"
      URI(base_url + path + object_id + auth)
    end

    def set_format_header(req)
      format_header = ClubhouseRuby::FORMATS[response_format][:header]
      format_content = ClubhouseRuby::FORMATS[response_format][:content]
      req[format_header] = format_content
    end

    def set_body(req)
      req.body = params.to_json if params
    end

    def wrap_response(res)
      # TODO
      # decorate errors
      # wrap with status
      res
    end
  end
end
