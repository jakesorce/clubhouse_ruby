require 'net/http'

module ClubhouseRuby
  class Request
    attr_accessor :uri, :method, :response_format, :params

    # Prepares a fancy request object and ensures the inputs make as much sense
    # as possible. It's still totally possible to just provide a path that
    # doesn't match a real url though.
    #
    def initialize(call_object, method:, params: {})
      raise ArgumentError unless validate_input(call_object, method, params)

      self.params = params || {}
      self.uri = construct_uri(call_object)
      self.method = method
      self.response_format = call_object.response_format
    end

    # Executes the http(s) request and provides the response with some
    # additional decoration in a Hash.
    #
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
        METHODS.values.include?(method) &&
        (params.is_a?(Hash) || params.nil?)
    end

    def construct_uri(call_object)
      base_url = API_URL
      path = call_object.path.map(&:to_s).map { |p| p.gsub('_', '-') }.join('/')
      object_id = "/#{self.params.delete(:id)}" if self.params.key?(:id)
      token = call_object.token
      URI("#{base_url}#{path}#{object_id}?token=#{token}")
    end

    def set_format_header(req)
      format_header = FORMATS[response_format][:headers][:header]
      format_content = FORMATS[response_format][:headers][:content]
      req[format_header] = format_content
    end

    def set_body(req)
      req.body = params.to_json if params
    end

    def wrap_response(res)
      {
        code: res.code,
        status: res.message,
        content: FORMATS[response_format][:parser].parse(res.body)
      }
    end
  end
end
