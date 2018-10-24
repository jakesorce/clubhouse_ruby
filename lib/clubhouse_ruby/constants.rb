require 'json'
require 'csv'

module ClubhouseRuby
  API_URL = "https://api.clubhouse.io/api/v2/".freeze

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
  ACTIONS = {
    get: :Get,
    update: :Put,
    delete: :Delete,
    list: :Get,
    create: :Post
  }.freeze

  # These are the resource for the clubhouse api and can form part of the path
  RESOURCES = [
    :categories,
    :epics,
    :files,
    :labels,
    :linked_files,
    :members,
    :milestones,
    :projects,
    :repositories,
    :stories,
    :story_links,
    :teams,
    :workflows,
    :tasks,
    :comments
  ].freeze

  # These are the annoying edge cases in the clubhouse api that are don't fit
  EXCEPTIONS = {
    bulk_create: {
      path: :bulk,
      action: :Post
    },
    bulk_update: {
      path: :bulk,
      action: :Put
    },
    search_stories: {
      path: 'search/stories',
      action: :Get
    }
  }.freeze
end
