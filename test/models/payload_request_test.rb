require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers



  def test_no_object_creation_on_blank_fields
    attempt = PayloadRequest.create(requested_at: "19394")
    refute attempt.valid?
  end

  def test_object_creation_on_valid_fields
    create_payload

    assert PayloadRequest.find(1).valid?
  end
end
