require_relative '../test_helper'

class ReferrerTest < Minitest::Test
  include TestHelpers
  def test_referrer_has_relationship_with_payload
    create_payload

    assert_equal "http://jumpstartlab.com", Referrer.all.first.referrer
  end
end
