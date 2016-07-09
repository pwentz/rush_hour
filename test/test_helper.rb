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

  def create_payload
    url         = Url.find_or_create_by(root_url: "http://jumpstartlab.com", path: "/blog")
    rtype       = RequestType.find_or_create_by(method_name: "GET")
    resolution  = Resolution.find_or_create_by(width: "1920", height: "1280")
    referrer    = Referrer.find_or_create_by(referrer: "http://jumpstartlab.com")
    user_agent  = UserAgent.find_or_create_by(operating_system: "OS X 10.8.2", browser: "Chrome")
    ip          = IPAddress.find_or_create_by(ip_address: "63.29.38.211")

    PayloadRequest.find_or_create_by(url_id: url.id,
                                        requested_at: Time.now,
                                        responded_in: "5",
                                        referrer_id: referrer.id,
                                        request_type_id: rtype.id,
                                        user_agent_id: user_agent.id,
                                        resolution_id: resolution.id,
                                        ip_address_id: ip.id)

  end

  def create_multiple_payloads(number)
    number.times do |i|
      url         = Url.find_or_create_by(root_url: "http://jumpstartlab.com", path: "/blog#{i}")
      rtype       = RequestType.find_or_create_by(method_name: "POST")
      resolution  = Resolution.find_or_create_by(width: "192#{i}", height: "128#{i}")
      referrer    = Referrer.find_or_create_by(referrer: "http://jumpstartlab.com#{i}")
      user_agent  = UserAgent.find_or_create_by(operating_system: "OSX 10.8.2#{i}", browser: "Chrome#{i}")
      ip          = IPAddress.find_or_create_by(ip_address: "63.29.38.211#{i}")

      PayloadRequest.find_or_create_by(url_id: url.id,
                                          requested_at: "abcd#{i}",
                                          responded_in: "#{i}",
                                          referrer_id: referrer.id,
                                          request_type_id: rtype.id,
                                          user_agent_id: user_agent.id,
                                          resolution_id: resolution.id,
                                          ip_address_id: ip.id)
    end
  end
end
