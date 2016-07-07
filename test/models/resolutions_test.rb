require_relative '../test_helper'
class ResolutionsTest < Minitest::Test
  include TestHelpers
  def test_resolutions_have_relationship_with_payload_requests
    create_payload

    assert_equal "1920", Resolution.all.first.width
    assert_equal "1280", Resolution.all.first.height
  end

  def test_list_of_resolutions_used
    create_payload
    create_multiple_payloads(3)

    assert_equal ["1920 x 1280", "1921 x 1281", "1922 x 1282"], Resolution.resolution_list
  end
end
