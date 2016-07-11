require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_payload_requst_has_relationships
    pr = PayloadRequest.new

    assert pr.respond_to?(:url)
    assert pr.respond_to?(:referrer)
    assert pr.respond_to?(:request_type)
    assert pr.respond_to?(:user_agent)
    assert pr.respond_to?(:ip_address)
    assert pr.respond_to?(:client)
    assert pr.respond_to?(:resolution)
  end

  def test_payload_request_has_requested_at_attribute
    pr = PayloadRequest.new(requested_at: "2013-02-16 21:38:28 -0700")

    assert_equal "2013-02-16 21:38:28 -0700", pr.requested_at
  end

  def test_payload_request_has_responded_in_attribute
    pr = PayloadRequest.new(responded_in: 5)

    assert_equal 5, pr.responded_in
  end

  def test_payload_request_created_w_valid_attributes
    pr = PayloadRequest.new(url_id: 1, requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 5, referrer_id: 1, request_type_id: 1,
                            user_agent_id: 1, resolution_id: 1, ip_address_id: 1)

    assert pr.valid?
  end

  def test_payload_not_created_w_invalid_attributes
    pr = PayloadRequest.new(url_id:1)

    refute pr.valid?
  end

  def test_payload_calculates_response_times
    dummy_payload(:responded_in, 5)
    dummy_payload(:responded_in, 35)

    assert_equal 20, PayloadRequest.average_response_time
    assert_equal 35, PayloadRequest.max_response_time
    assert_equal 5, PayloadRequest.min_response_time
  end

  def test_requested_url_breakdown_descending_order
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    url_two = Url.create(root_url: "http://mysite.com", path: "/blog")
    url_three = Url.create(root_url: "http://jumpstartlab.com", path: "/store")

    dummy_payload(:url_id, url_one.id, 2)
    dummy_payload(:url_id, url_three.id, 4)
    dummy_payload(:url_id, url_two.id, 3)

    assert_equal "http://jumpstartlab.com/store", PayloadRequest.top_requested_url
    assert_equal "http://jumpstartlab.com/blog", PayloadRequest.min_requested_url
    assert_equal "http://mysite.com/blog", PayloadRequest.requested_urls_in_descending_order.keys[1]
  end
end
