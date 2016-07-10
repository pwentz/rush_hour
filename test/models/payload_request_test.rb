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

  def test_payload_calculates_most_frequent_id_of_any_attribute
    skip
    PayloadRequest.create(url_id: 1, requested_at: "2012-02-16 21:38:28 -0700",
                            responded_in: 35, referrer_id: 1, request_type_id: 1,
                            user_agent_id: 1, resolution_id: 1, ip_address_id: 1)
    PayloadRequest.create(url_id: 1, requested_at: "2012-02-16 21:38:28 -0800",
                            responded_in: 35, referrer_id: 1, request_type_id: 3,
                            user_agent_id: 1, resolution_id: 2, ip_address_id: 2)
    PayloadRequest.create(url_id: 2, requested_at: "2012-02-16 21:38:28 -0900",
                            responded_in: 35, referrer_id: 2, request_type_id: 2,
                            user_agent_id: 2, resolution_id: 3, ip_address_id: 2)
    PayloadRequest.create(url_id: 3, requested_at: "2012-02-16 21:38:28 -1000",
                            responded_in: 35, referrer_id: 3, request_type_id: 3,
                            user_agent_id: 3, resolution_id: 3, ip_address_id: 3)

    assert_equal 1, PayloadRequest.most_frequent(:url_id)
    assert_equal 1, PayloadRequest.most_frequent(:referrer_id)
    assert_equal 3, PayloadRequest.most_frequent(:request_type_id)
    assert_equal 1, PayloadRequest.most_frequent(:user_agent_id)
    assert_equal 3, PayloadRequest.most_frequent(:resolution_id)
    assert_equal 2, PayloadRequest.most_frequent(:ip_address_id)
  end
end
