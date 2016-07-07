require_relative '../test_helper'

class IPAddressTest < Minitest::Test
  include TestHelpers
  def test_ip_has_relationship_with_payload
    create_payload

    require 'pry'; binding.pry
    assert_equal "63.29.38.211", IPAddress.all.first.ip_address
    assert_equal "abcd", IPAddress.find(1).payload_requests.find(1).requested_at
  end
end
