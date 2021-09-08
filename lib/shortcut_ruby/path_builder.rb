module ShortcutRuby
  module PathBuilder
    def self.included(_)
      class_exec do
        attr_accessor :path
      end
    end

    # Uh oh! This will allow the class including this module to "build a path"
    # by chaining calls to resources, terminated with a method linked to an
    # action that will execute the api call.
    #
    # For example:
    #
    # `foo.stories(story_id).comments.update(id: comment_id, text: "comment text")`
    #
    # This example will execute a call to:
    #
    # `https://api.app.shortcut.com/api/v3/stories/{story-id}/comments/{comment-id}`
    #
    # with arguments:
    #
    #   `{ text: "comment text" }`
    #
    def method_missing(name, *args)
      if known_action?(name)
        execute_request(ACTIONS[name], args.first)
      elsif known_resource?(name)
        build_path(name, args.first)
      elsif known_exception?(name)
        build_path(EXCEPTIONS[name][:path], nil)
        execute_request(EXCEPTIONS[name][:action], args.first)
      else
        super
      end
    end

    # You can build a path without executing in stages like this:
    #
    # `foo.stories(story_id)`
    #
    # This will partly populate foo:path, but won't execute the call (which
    # clears it). In case you made a mistake and want to start again, you can
    # clear the path using this public method.
    #
    def clear_path
      self.path = []
    end

    # We'd better not lie when asked.
    #
    def respond_to_missing?(name, include_private = false)
      known_action?(name) ||
        known_resource?(name) ||
        known_exception?(name) ||
        super
    end

    private

    def known_action?(name)
      ACTIONS.keys.include?(name)
    end

    def known_resource?(name)
      RESOURCES.include?(name)
    end

    def known_exception?(name)
      EXCEPTIONS.keys.include?(name)
    end

    def execute_request(action, params)
      req = Request.new(
        self,
        action: action,
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
