module ClubhouseRuby
  API_URL = "https://api.clubhouse.io/api/v1/".freeze

  FORMATS = {
    json: { header: 'Content-Type', content: 'application/json' },
    csv: { header: 'Accept', content: 'text/csv' }
  }.freeze

  METHODS = {
    get: :Get,
    update: :Put,
    delete: :Delete,
    list: :Get,
    create: :Post,
    search: :Post
  }.freeze
end
