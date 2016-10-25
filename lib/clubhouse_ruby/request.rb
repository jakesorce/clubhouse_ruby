require 'net/http'

module ClubhouseRuby
  class Request
    attr_accessor :uri, :action, :response_format, :params

    # Prepares a fancy request object and ensures the inputs make as much sense
    # as possible. It's still totally possible to just provide a path that
    # doesn't match a real url though.
    #
    def initialize(clubhouse, action:, params: {})
      raise ArgumentError unless validate_input(clubhouse, action, params)

      self.params = params || {}
      self.uri = construct_uri(clubhouse)
      self.action = action
      self.response_format = clubhouse.response_format
    end

    # Executes the http(s) request and provides the response with some
    # additional decoration in a Hash.
    #
    def fetch
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |https|
        req = Net::HTTP.const_get(action).new(uri)

        set_body(req)
        set_format_header(req)

        wrap_response(https.request(req))
      end
    end

    private

    def validate_input(clubhouse, action, params)
      clubhouse.is_a?(Clubhouse) &&
        !clubhouse.path.nil? &&
        !clubhouse.token.nil? &&
        !clubhouse.response_format.nil? &&
        ACTIONS.values.include?(action) &&
        (params.is_a?(Hash) || params.nil?)
    end

    def construct_uri(clubhouse)
      base_url = API_URL
      path = clubhouse.path.map(&:to_s).map { |p| p.gsub('_', '-') }.join('/')
      object_id = "/#{self.params.delete(:id)}" if self.params.key?(:id)
      token = clubhouse.token
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
      begin
        content = FORMATS[response_format][:parser].parse(res.body) if res.body
      rescue FORMATS[response_format][:parser]::ParserError
        content = res.body
      end

      {
        code: res.code,
        status: res.message,
        content: content
      }
    end
  end
end
