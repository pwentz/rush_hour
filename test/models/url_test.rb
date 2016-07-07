require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_ip_address_has_payloads
    create_payload

    assert_equal "http://jumpstartlab.com", Url.all.first.root_url
    assert_equal "/blog", Url.all.first.path
  end

  def test_most_requested_to_least_requested
    2.times do
      create_payload
    end
    create_multiple_payloads(3)

    assert_equal "http://jumpstartlab.com/blog", Url.most_requested_to_least_requested.keys.first
    assert_equal 2, Url.most_requested_to_least_requested.values.first
  end

  def test_payload_max_response_time
    create_payload
    payload = PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "6",
                                      referrer_id: 1, request_type_id: 1,
                                      user_agent_id: 1, resolution_id: 1,
                                      ip_address_id: 1)

    assert_equal 6, Url.find(1).max_response_time
  end

  def test_payload_min_response_time
    create_payload
    payload = PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "6",
                                      referrer_id: 1, request_type_id: 1,
                                      user_agent_id: 1, resolution_id: 1,
                                      ip_address_id: 1)

    assert_equal 5, Url.find(1).min_response_time
  end

  def test_payload_avg_response_time
    create_payload
    payload = PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
                                      referrer_id: 1, request_type_id: 1,
                                      user_agent_id: 1, resolution_id: 1,
                                      ip_address_id: 1)

    assert_equal 20, Url.find(1).average_response_time
  end

  def test_payload_avg_response_time
    create_payload
    payload = PayloadRequest.create(url_id: 1, requested_at: "abcd", responded_in: "35",
                                      referrer_id: 1, request_type_id: 1,
                                      user_agent_id: 1, resolution_id: 1,
                                      ip_address_id: 1)

    Url.find(1).http_verbs
  end
end
