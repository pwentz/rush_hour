require_relative '../test_helper'

class ReferrerTest < Minitest::Test
  include TestHelpers
  
  def test_ref_has_relationship_with_payload
    ref = Referrer.new
    assert ref.respond_to?(:payload_requests)
  end

  def test_ref_has_an_address_attribute
    ref = Referrer.new(referrer: "http://www.google.com")

    assert_equal "http://www.google.com", ref.referrer
  end

  def test_ref_is_created_w_valid_attributes
    ref = Referrer.new(referrer: "http://www.google.com")

    assert ref.valid?
  end

  def test_ref_is_not_created_w_invalid_attributes
    ref = Referrer.new

    refute ref.valid?
  end

  def test_ref_uniqueness
    ref_one = Referrer.create(referrer: "http://www.google.com")
    ref_two = Referrer.create(referrer: "http://www.google.com")

    assert ref_one.valid?
    refute ref_two.valid?
    assert_equal 1, Referrer.count
  end
end
