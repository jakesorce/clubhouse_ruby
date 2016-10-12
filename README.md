# ClubhouseRuby

ClubhouseRuby is a Ruby wrapper of the
[Clubhouse API](https://clubhouse.io/api/v1/).

Clubhouse is a radical project management tool particularly well suited to
software development! :heart:

This gem exists to provide a nice interface to the API in your Ruby projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clubhouse_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clubhouse_ruby

Or transcribe the code by carving it character by character into the
mechanically articulated hand built stone sculpture you've developed that
operates as an effective turing machine when lubricated with oil.

## Usage

This gem is a simple API wrapper. That means you'll need to refer to the
[API documentation](https://clubhouse.io/api/v1/) to figure out what resources
 and actions exist.

On the plus side, once you know what you want to do, using this gem should be 
simple.

Instantiate an object to interface with the API:

```ruby
clubhouse = ClubhouseRuby::Clubhouse.new(<YOUR CLUBHOUSE API TOKEN>)
```

The API can also provide responses in CSV format instead of the default JSON:

```ruby
clubhouse = ClubhouseRuby::Clubhouse.new(<YOUR CLUBHOUSE API TOKEN>, response_format: :csv)
```

Then call methods on the object matching the resource(s) and action you are
interested in:

```ruby
clubhouse.epics.list
# => {
#   code: "200",
#   status: "OK",
#   content: [
#     {
#       "id" => 1,
#       "name" => "An Odyssian Epic",
#       "description" => "Outrageously epic.",
#       "created_at" => "...",
#       "updated_at" => "...",
#       "deadline "=> "...",
#       "state" => "to do",
#       "position" => 1,
#       "archived" => false,
#       "follower_ids" => ["..."],
#       "owner_ids" => ["..."],
#       "comments" => []
#      }
#    ]
# }
```

You can build a path to a nested resource:

```ruby
clubhouse.projects(project_id).stories.list
# => {
#   code: "200",
#   status: "OK",
#   content: [
#     {
#       "archived" => false,
#       "created_at" => "...",
#       "id" => 1,
#       "name" => "Rescue Prince",
#       "story_type" => "feature",
#       "description" => "The prince is trapped in a tower and needs freeing.",
#       "position" => "...",
#       "workflow_state_id" => "...",
#       "estimate" => "...",
#       "updated_at" => "...",
#       "deadline" => nil,
#       "project_id" => 1,
#       "labels" => [
#         {
#           "id" => 21,
#           "name" => "Urgent",
#           "created_at" => "...",
#           "updated_at" => "..."
#         }
#       ],
#       "requested_by_id" => "...",
#       "owner_ids" => [...],
#       "follower_ids" => [...],
#       "epic_id" => "...",
#       "file_ids" => [...],
#       "linked_file_ids" => [...],
#       "comments" => [...],
#       "tasks" => [...],
#       "story_links" => [...]
#     },
#     {...},
#     {...}
#   ]
# }
```

You can build a path in steps:

```ruby
clubhouse.projects(project_id)
clubhouse.stories
clubhouse.list
# => the same result as above
```

If you are building a path and you make a mistake, you can clear the path:

```ruby
clubhouse.projects(project_id)
clubhouse.epics
clubhouse.clear_path
# => []
```

You don't need to clear the path after a request, as that happens automatically.

Note that the chained methods are always resources (with an id for a parent
when accessing nested resources) followed by a final "action" or "method" that
matches the methods in the Clubhouse API documentation.

These resources and methods are enumerated in the source code
[here](https://github.com/PhilipCastiglione/clubhouse_ruby/blob/master/lib/clubhouse_ruby/constants.rb)
but generally you should find the url you are interested in from the docs.

## Errors

Errors are passed through from the API relatively undecorated:

```ruby
clubhouse = ClubhouseRuby::Clubhouse.new("unrecognized token")
clubhouse.epics.list
# => {
#   code: "401",
#   status: "Unauthorized",
#   content: {
#     "message" => "Unauthorized",
#     "tag" => "unauthorized"
#   }
# }
```

Arbitrary combinations of resources not building a path that matches a url the
API knows about will fail. Note the clubhouse API gives little away, returning
forbidden:

```ruby
clubhouse.epics(epic_id).stories.list
# => {
#   code: "403",
#   status: "Forbidden",
#   content: {
#     "message" => "Sorry, you do not have access to this resource.",
#     "tag" => "user_denied_access"
#   }
# }
```

Attempting to access a nested resource without providing the parent id as an
argument is a bad request:

```ruby
clubhouse.projects.stories.list
# => {
#   code: "400",
#   status: "Bad Request",
#   content: {
#     "message" => "The request included invalid or missing parameters.",
#     "errors" => {
#       "project-public-id" => [
#         "not", [
#           "integer?",
#           "projects"
#         ]
#       ]
#     }
#   }
# }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies and
following the instructions.

Use `rake spec` to run the tests. Except don't, because they won't work for you
yet. TODO!

You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

## Contributing

Bug reports and pull requests are (probably unlikely, but) welcome on GitHub at
https://github.com/philipcastiglione/clubhouse_ruby.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## TODO

- Actually accept csv response format
- The specs just use magic numbers based on things I entered in a Clubhouse account to try things out
- The specs shared context and are generally rushed and bad
- The errors/logs for a user are not great and can be improved
- Publish the gem
