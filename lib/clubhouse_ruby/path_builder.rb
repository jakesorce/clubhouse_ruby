module ClubhouseRuby
  module PathBuilder
    def self.included(_)
      class_exec do
        attr_accessor :path
      end
    end

    def method_missing(name, *args)
      if ClubhouseRuby::METHODS.keys.include?(name)
        req = ClubhouseRuby::Request.new(
          self, 
          method: ClubhouseRuby::METHODS[name],
          params: args.first
        )
        clear_path
        req.fetch
      elsif ClubhouseRuby::RESOURCES.include?(name)
        build_path(name, args.first)
        self
      else
        super
      end
    end

    def build_path(resource, id)
      self.path ||= []
      self.path << resource
      self.path << id if id
    end

    def clear_path
      self.path = []
    end

    def respond_to_missing?(name, include_private = false)
      ClubhouseRuby::METHODS.keys.include?(name) || ClubhouseRuby::RESOURCES.include?(name) || super
    end
  end
end
