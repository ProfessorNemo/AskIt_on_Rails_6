# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.ignore_hosts 'codeclimate.com'
  c.hook_into :webmock
  c.default_cassette_options = {
    decode_compressed_response: true
  }
  c.cassette_library_dir = File.join(
    File.dirname(__FILE__), '..', 'support', 'vcr_cassettes'
  )
  c.filter_sensitive_data('<TOKEN>') do
    ENV.fetch('TOKEN', 'hidden')
  end
end
