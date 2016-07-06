ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'rack/test'
require 'database_cleaner'
require 'pry'

Capybara.app = RushHour::Server

DatabaseCleaner.strategy = :truncation

module TestHelpers

  def setup
    DatabaseCleaner.start
    super
  end

  def teardown
    DatabaseCleaner.clean
    super
  end
end
