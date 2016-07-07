require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_no_object_creation_on_blank_fields
    attempt = PayloadRequest.new(:responded_in => "5")
    refute attempt.save
  end

  def test_object_creation_on_valid_fields
    create_multiple_payloads(2)

    assert PayloadRequest.find(1).valid?
    assert PayloadRequest.find(2).valid?
  end

  def test_average_response_time
    create_multiple_payloads(3)

    assert_equal 1, PayloadRequest.average_response_time
  end

  def test_max_response_time
    create_multiple_payloads(10)

    assert_equal 9, PayloadRequest.max_response_time
  end

  def test_min_response_time
    create_multiple_payloads(10)

    assert_equal 0, PayloadRequest.min_response_time
  end

  def test_average_response_time_per_site
    create_multiple_payloads(2)

    assert_equal 0, payload_requests.average_response_time_per_site("http://jumpstartlab.com", "/blog0")
    assert_equal 1, payload_requests.average_response_time_per_site("http://jumpstartlab.com", "/blog1")
  end
end
