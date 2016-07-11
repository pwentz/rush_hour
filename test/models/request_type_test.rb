require_relative '../test_helper'

class RequestTypeTest < Minitest::Test
  include TestHelpers

  def test_request_types_have_relationship_with_payload
    rt = RequestType.new

    assert rt.respond_to?(:payload_requests)
  end

  def test_request_type_has_method_name_attribute
    rt = RequestType.new(method_name: "GET")

    assert_equal "GET", rt.method_name
  end

  def test_request_type_created_w_valid_attributes
    rt = RequestType.new(method_name: "GET")

    assert rt.valid?
  end

  def test_request_type_not_created_w_invalid_attributes
    rt = RequestType.new

    refute rt.valid?
  end

  def test_request_type_uniqueness
    rt_one = RequestType.create(method_name: "GET")
    rt_two = RequestType.create(method_name: "GET")

    assert rt_one.valid?
    refute rt_two.valid?
    assert_equal 1, RequestType.count
  end
end
