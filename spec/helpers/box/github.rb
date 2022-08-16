# frozen_string_literal: true

module Box
  module Github
    def self.user(name)
      url  = "https://api.github.com/users/#{name}"
      data = Faraday.get(url).body

      JSON.parse(data, symbolize_names: true)
    end
  end
end
