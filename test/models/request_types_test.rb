require_relative '../test_helper'

class RequestTypesTest < Minitest::Test
  include TestHelpers
  def test_request_types_have_relationship_with_payload
    create_payload
    assert_equal "GET", RequestType.all.first.method_name
  end
end
