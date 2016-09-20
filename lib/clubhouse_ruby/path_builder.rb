module ClubhouseRuby
  module PathBuilder
    def self.included(_)
      class_exec do
        attr_accessor :path
      end
    end

    def clear_path
      self.path = []
    end

    def method_missing(name, *args)
      if known_method?(name)
        execute_request(name, args.first)
      elsif known_resource?(name)
        build_path(name, args.first)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      ClubhouseRuby::METHODS.keys.include?(name) || ClubhouseRuby::RESOURCES.include?(name) || super
    end

    private

    def known_method?(name)
      ClubhouseRuby::METHODS.keys.include?(name)
    end

    def known_resource?(name)
      ClubhouseRuby::RESOURCES.include?(name)
    end

    def execute_request(method, params)
      req = ClubhouseRuby::Request.new(
        self, 
        method: ClubhouseRuby::METHODS[method],
        params: params
      )
      clear_path
      req.fetch
    end

    def build_path(resource, id)
      self.path ||= []
      self.path << resource
      self.path << id if id
      self
    end
  end
end
