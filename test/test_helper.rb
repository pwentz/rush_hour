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

class FeatureTest < Minitest::Test
  include Capybara::DSL
end

DatabaseCleaner.strategy = :truncation

module TestHelpers
  include Rack::Test::Methods

  def app
    RushHour::Server
  end

  def setup
    DatabaseCleaner.start
    super
  end

  def teardown
    DatabaseCleaner.clean
    super
  end

  def dummy_payload(type, id, number=1, dummy=35)
    number.times do
      PayloadRequest.create({url_id: 1, requested_at: rand(1000), responded_in: dummy += 1,
                            request_type_id: 1, referrer_id: 1, user_agent_id: 1, 
                            resolution_id: 1, ip_address_id: 2}.merge(type => id))
    end
  end

  def url_create(root, path)
    Url.create(root_url: root, path: path)
  end

  def request_type_create(method_name)
    RequestType.create(method_name: method_name)
  end

  def resolution_create(width, height)
    Resolution.create(height: height, width: width)
  end
  
  def user_agent_create(os, browser)
    UserAgent.create(operating_system: os, browser: browser)
  end

  def referrer_create(referrer)
    Referrer.create(referrer: referrer)
  end
  
  def ip_address_create(ip_address)
    IPAddress.create(ip_address: ip_address)
  end

  def client_create(identifier, root_url)
    Client.create(identifier: identifier, root_url: root_url)
  end

  def client_to_payloads(client)
    client.payload_requests << PayloadRequest.all
  end

end
