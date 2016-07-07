require_relative '../test_helper'

class IPAddressTest < Minitest::Test
  include TestHelpers
  def test_ip_has_relationship_with_payload
    create_payload

    assert_equal "63.29.38.211", IPAddress.all.first.ip_address
  end
end
