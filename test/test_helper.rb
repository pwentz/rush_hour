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
    url         = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    rtype       = RequestType.create(method_name: "GET")
    resolution  = Resolution.create(width: "1920", height: "1280")
    referrer    = Referrer.create(referrer: "http://jumpstartlab.com")
    user_agent  = UserAgent.create(operating_system: "OSX 10.8.2", browser: "Chrome")
    ip          = IPAddress.create(ip_address: "63.29.38.211")

    payload     = PayloadRequest.create(url_id: url.id,
                                        requested_at: "abcd",
                                        responded_in: "5",
                                        referrer_id: referrer.id,
                                        request_type_id: rtype.id,
                                        user_agent_id: user_agent.id,
                                        resolution_id: resolution.id,
                                        ip_address_id: ip.id)
    
  end

  def create_multiple_payloads(number)
    number.times do |i|
      url         = Url.create(root_url: "http://jumpstartlab.com", path: "/blog#{i}")
      rtype       = RequestType.create(method_name: "POST")
      resolution  = Resolution.create(width: "192#{i}", height: "128#{i}")
      referrer    = Referrer.create(referrer: "http://jumpstartlab.com#{i}")
      user_agent  = UserAgent.create(operating_system: "OSX 10.8.2#{i}", browser: "Chrome#{i}")
      ip          = IPAddress.create(ip_address: "63.29.38.211#{i}")

      payload     = PayloadRequest.create(url_id: url.id,
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
