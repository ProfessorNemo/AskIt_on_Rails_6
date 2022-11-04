# frozen_string_literal: true

module Blacklist
  extend ActiveSupport::Concern

  included do
    def blacklist
      @blacklist ||= Rails.root.join('lib/blacklist.txt').readlines
      @blacklist.map(&:strip)
    end
  end
end
