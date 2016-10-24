require 'json'
require 'csv'

module ClubhouseRuby
  API_URL = "https://api.clubhouse.io/api/v1/".freeze

  # Response formats the clubhouse api knows about
  FORMATS = {
    json: {
      headers: { header: 'Content-Type', content: 'application/json' },
      parser: JSON
    },
    csv: {
      headers: { header: 'Accept', content: 'text/csv' },
      parser: CSV
    }
  }.freeze

  # Action words are nice for our internal api and match the api path too
  METHODS = {
    get: :Get,
    update: :Put,
    delete: :Delete,
    list: :Get,
    create: :Post,
    search: :Post
  }.freeze

  # These are the resource for the clubhouse api and can form part of the path
  RESOURCES = [
    :epics,
    :files,
    :labels,
    :linked_files,
    :projects,
    :story_links,
    :stories,
    :bulk,
    :tasks,
    :comments,
    :users,
    :workflows
  ].freeze
end
