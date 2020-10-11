require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
end
require 'minitest/reporters'
require 'minitest/autorun'
require 'minitest/skip_dsl'
require 'minitest/pride'
require "vcr"
require "webmock/minitest"
require "dotenv"
Dotenv.load


Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock 
  config.default_cassette_options = {
    :record => :new_episodes,
    :match_requests_on => [:method, :uri, :body],
  }
  
  # config.allow_http_connections_when_no_cassette = true
  
  config.filter_sensitive_data("SLACK_TOKEN") do
    ENV['SLACK_TOKEN']
  end
end
