# frozen_string_literal: true

module Box
  module TagsJson
    def self.tags
			# byebug
      url  = 'http://127.0.0.1:3000/api/tags'
      data = Faraday.get(url).body

      JSON.parse(data, symbolize_names: true)
    end
  end
end
