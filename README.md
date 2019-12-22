# ClubhouseRuby

ClubhouseRuby is a lightweight Ruby wrapper of the
[Clubhouse REST API](https://clubhouse.io/api/rest/v3/).

[Clubhouse](https://clubhouse.io) is a radical project management tool
particularly well suited to software development. If you're not familiar with
them, go check them out! :heart:

This gem is built with the philosophy that a good API wrapper is a simpler
alternative to a comprehensive client library and can provide a nice interface
to the API using dynamic Ruby metaprogramming techniques rather than mapping
functionality from the API to the library piece by piece.

This enables the wrapper to be loosely coupled to the current implementation of
the API, which makes it more resilient to change. Also, this approach takes much
less code and maintenance effort, allowing the developer to be lazy. A
reasonable person might fairly assume this to be the true rationale behind the
philosophy. They'd be right.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clubhouse_ruby'
```

And then execute:

    $ bundle

Or install it globally:

    $ gem install clubhouse_ruby

Or transcribe the code by carving it character by character into the
mechanically articulated hand built stone sculpture you've developed that
operates as an effective turing machine when lubricated with oil.

## Usage

This gem is a lightweight API wrapper. That means you'll need to refer to the
[API documentation](https://clubhouse.io/api/rest/v3/) to figure out what resources
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

Then, call methods on the object matching the resource(s) and action you are
interested in. For example, if you want to list all available epics, you need to
access the endpoint at https://api.clubhouse.io/api/v1/epics. The
clubhouse_ruby gem uses an explicit action:

```ruby
clubhouse.epics.list
# => {
#   code: "200",
#   status: "OK",
#   content: [
#    {
#      "entity_type" => "epic",
#      "id" => 1,
#      "external_id" => nil,
#      "name" => "An Odyssian Epic",
#      "description" => "Outrageously epic.",
#      "created_at" => "...",
#      "updated_at" => "...",
#      "deadline "=> nil,
#      "state" => "to do",
#      "position" => 1,
#      "started" => false,
#      "started_at" => nil,
#      "started_at_override" => nil,
#      "completed" => false,
#      "completed_at" => nil,
#      "completed_at_override" => nil,
#      "archived" => false,
#      "labels" => [...],
#      "milestone_id" => nil,
#      "follower_ids" => [...],
#      "owner_ids" => [...],
#      "project_ids" => [...],
#      "comments" => [...],
#      "stats" => {...},
#     }, ...
#   ]
# }
```

If the endpoint you want requires parameters, say if you wanted to create an
epic, you provide a hash to the action call following the resource:

```ruby
clubhouse.epics.create(name: "My New Epic", state: "to do")
# => {
#   code: "201",
#   status: "Created",
#   content: {
#     "entity_type" => "epic",
#     "id" => 2,
#     "extenal_id" => nil,
#     "name" => "My New Epic",
#     "description" => "",
#     ...
#   }
# }
```

If the endpoint you want is nested, you can build a path by chaining method
calls, providing any required parent resource id as an argument to that method
in the chain. For example, if you wanted to list all the stories associated
with a particular project:

```ruby
clubhouse.projects(<project_id>).stories.list
# => {
#   code: "200",
#   status: "OK",
#   content: [
#     {
#       "entity_type" => "story",
#       "archived" => false,
#       "created_at" => "...",
#       "updated_at" => "...",
#       "id" => 1,
#       "external_id" => nil,
#       "name" => "Rescue Prince",
#       "story_type" => "feature",
#       "description" => "The prince is trapped in a tower and needs freeing.",
#       "position" => 1,
#       ...
#     }, ...
#   ]
# }
```

You can search stories, using standard Clubhouse [search operators](https://help.clubhouse.io/hc/en-us/articles/360000046646-Search-Operators):

```ruby
clubhouse.search_stories(page_size: 25, query: 'state:500000016')
# => {
#   code: "200",
#   status: "OK",
#   content: {
#     "next" => "/api/v3/search/stories?query=state%3A500000016&page_size=25&next=a8acc6577548df7a213272f7f9f617bcb1f8a831~24",
#     "data" => [
#       {
#         "entity_type" => "story",
#         "archived" => false,
#         "created_at" => "...",
#         "updated_at" => "...",
#         ...
#       }, ...
#     ]
#   }
# }
```

You can build a path in steps rather than all at once, and execution is deferred
until the action call:

```ruby
clubhouse.projects(<project_id>)
clubhouse.stories
clubhouse.list
# => as above
```

If you are building a path and you make a mistake, you can clear the path:

```ruby
clubhouse.projects(project_id)
clubhouse.epics
clubhouse.clear_path
# => []
```

You don't need to clear the path after a complete request, as that happens
automatically.

Note that the chained methods are always resources (with an id for a parent when
accessing nested resources) followed by a final action that matches the methods
in the Clubhouse API documentation.

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
API knows about will fail.

```ruby
clubhouse.epics(epic_id).stories.list
# => {
#   code: "404",
#   status: "Not Found",
#   content: {
#     "message" => "Page not Found"
#   }
# }
```

Note: the v1 API returns forbidden rather than not found.

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

## Version

The current version of the clubhouse_ruby gem supports the current version of
the API, version 3.

If you want something that definitely works with:

* v1, use version 0.2.0 of clubhouse_ruby
* v2, use version 0.3.0 of clubhouse_ruby

## Development

After checking out the repo, run `bin/setup` to install dependencies and
following the instructions. Specifically, you can choose to provide a genuine
Clubhouse API token in the `.env` file. This will be important if you want to
use `bin/console` for an interactive prompt that allows you to experiment with
the gem and real API responses.

Use `rake spec` to run the tests. The tests don't make external requests but
rather use VCR for stubbed responses. If you want to play with the tests and
get real API responses (perhaps to extend the suite or for a new feature) then
you'll need to have an API token in the env as described above.

Note that the current test suite is far from exhaustive and could do with some
love.

**NB: If you have implemented a feature that requires a new cassette, make sure
you change the uri referenced by the cassette you added to remove the API token
if you have updated the environment to use your token. Otherwise your API token
will be in publically visible from the code in this repo.**

## Contributing

Bug reports and pull requests are entirely welcome on GitHub at
https://github.com/philipcastiglione/clubhouse_ruby.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
