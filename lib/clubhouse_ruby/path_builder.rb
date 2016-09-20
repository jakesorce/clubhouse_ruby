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
        self.path = []
        req.fetch
      else
        self.path ||= []
        self.path << name
        self.path << args.first if args.first
        self
      end
    end

    def respond_to_missing?
      #TODO
    end
  end
end
