require_relative '../test_helper'

class RequestTypesTest < Minitest::Test
  include TestHelpers
  def test_request_types_have_relationship_with_payload
    create_payload
    assert_equal "GET", RequestType.all.first.method_name
  end

  def test_most_frequent_request_type
    create_payload

    assert_equal "GET", RequestType.most_frequent_request_type

    create_multiple_payloads(3)

    assert_equal "POST", RequestType.most_frequent_request_type
  end

  def test_list_of_request_verbs_used
    create_payload
    create_multiple_payloads(3)

    assert_equal ["GET", "POST"], RequestType.http_verbs
  end
end
