require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_no_object_creation_on_blank_fields
    attempt = PayloadRequest.create(url: "https:/akdjsakjsd/asd", requestedAt: "19394")
    refute attempt.valid?
  end

  def test_object_creation_on_valid_fields
    attempt = PayloadRequest.create(url: "https:/akdjsakjsd/asd", requestedAt: "19394",
                                    respondedIn: 23, referredBy: "adadkj", requestType: "dadasda",
                                    userAgent: "jkadsd", resolutionWidth: "12", resolutionHeight: "21",
                                    ip: "yajm")
    assert attempt.valid?
  end
end
