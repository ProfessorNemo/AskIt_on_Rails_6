# frozen_string_literal: true

module Blacklist
  extend ActiveSupport::Concern

  included do
    def blacklist
      @blacklist ||= File.readlines(Rails.root.join('lib', 'blacklist.txt'))
      @blacklist.map(&:strip)
    end
  end
end
