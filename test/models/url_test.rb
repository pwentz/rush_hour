require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  # def test_ip_address_has_payloads
  #   create_payload
  #
  #   assert_equal "http://jumpstartlab.com", Url.all.first.root_url
  #   assert_equal "/blog", Url.all.first.path
  # end
  #
  # def test_most_requested_to_least_requested
  #   2.times do
  #     create_payload
  #   end
  #   create_multiple_payloads(3)
  #   assert_equal "http://jumpstartlab.com/blog", Url.most_requested_to_least_requested.keys.first
  #   assert_equal 2, Url.most_requested_to_least_requested.values.first
  # end
  #
  # def test_payload_max_response_time
  #   create_payload
  #   PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "6",
  #                                     referrer_id: 1, request_type_id: 1,
  #                                     user_agent_id: 1, resolution_id: 1,
  #                                     ip_address_id: 1)
  #
  #   assert_equal 6, Url.find(1).max_response_time
  # end
  #
  # def test_payload_min_response_time
  #   create_payload
  #   PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "6",
  #                                     referrer_id: 1, request_type_id: 1,
  #                                     user_agent_id: 1, resolution_id: 1,
  #                                     ip_address_id: 1)
  #
  #   assert_equal 5, Url.find(1).min_response_time
  # end
  #
  # def test_payload_avg_response_time
  #   create_payload
  #   PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
  #                                     referrer_id: 1, request_type_id: 1,
  #                                     user_agent_id: 1, resolution_id: 1,
  #                                     ip_address_id: 1)
  #
  #   assert_equal 20, Url.find(1).average_response_time
  # end
  #
  # def test_http_verbs_by_url
  #   create_payload
  #   RequestType.create(:method_name => "POST")
  #   PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
  #                                     referrer_id: 1, request_type_id: 2,
  #                                     user_agent_id: 1, resolution_id: 1,
  #                                     ip_address_id: 1)
  #
  #   assert_equal ["GET", "POST"], Url.find(1).http_verbs
  # end
  #
  def test_top_referrers

    create_payload
    Referrer.create(:referrer => "www.google.com")
    Referrer.create(:referrer => "www.google.com")
    Referrer.create(:referrer => "www.bing.com")
    Referrer.create(:referrer => "www.duckduckgo.com")
    PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
                                      referrer_id: 2, request_type_id: 2,
                                      user_agent_id: 1, resolution_id: 1,
                                      ip_address_id: 1)
    PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
                                      referrer_id: 3, request_type_id: 2,
                                      user_agent_id: 1, resolution_id: 1,
                                      ip_address_id: 1)
    PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
                                      referrer_id: 4, request_type_id: 2,
                                      user_agent_id: 1, resolution_id: 1,
                                      ip_address_id: 1)


    assert_equal 3, Url.find(1).top_referrers.count
    assert_equal "www.google.com", Url.find(1).top_referrers.first
  end

  def test_top_user_agents
    create_payload
    UserAgent.create(:browser => "Chrome", :operating_system => "OS X 10.8.2")
    UserAgent.create(:browser => "Firefox", :operating_system => "OS X 10.8.2")
    UserAgent.create(:browser => "Safari", :operating_system => "OS X 10.8.2")
    PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
                                      referrer_id: 1, request_type_id: 1,
                                      user_agent_id: 2, resolution_id: 1,
                                      ip_address_id: 1)
    PayloadRequest.create(url_id: 1, requested_at: "abcd1", responded_in: "35",
                                      referrer_id: 1, request_type_id: 1,
                                      user_agent_id: 3, resolution_id: 1,
                                      ip_address_id: 1)
    PayloadRequest.create(url_id: 1, requested_at: "abcd2", responded_in: "35",
                                      referrer_id: 1, request_type_id: 1,
                                      user_agent_id: 3, resolution_id: 2,
                                      ip_address_id: 1)

    # require "pry"; binding.pry
    assert_equal 3, Url.find(1).top_user_agents.count
    assert_equal ["OS X 10.8.2", "Safari"], Url.find(1).top_user_agents.first
  end
end
