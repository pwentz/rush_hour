require_relative '../test_helper'

class IPAddressTest < Minitest::Test
  include TestHelpers

  def test_ip_has_relationship_with_payload
    ip = IPAddress.new
    assert ip.respond_to?(:payload_requests)
  end

  def test_ip_has_an_address_attribute
    ip = IPAddress.new(ip_address: "63.29.38.211")

    assert_equal "63.29.38.211", ip.ip_address
  end

  def test_ip_is_created_w_valid_attributes
    ip = IPAddress.new(ip_address: "63.29.38.211")

    assert ip.valid?
  end

  def test_ip_is_not_create_w_invalid_attributes
    ip = IPAddress.new

    refute ip.valid?
  end

  def test_ip_uniqueness
    ip_one = IPAddress.create(ip_address: "63.29.38.211")
    ip_two = IPAddress.create(ip_address: "63.29.38.211")

    assert ip_one.valid?
    refute ip_two.valid?
    assert_equal 1, IPAddress.count
  end
end
