require_relative '../test_helper'

class ResolutionTest < Minitest::Test
  include TestHelpers

  def test_resolutions_have_relationship_with_payload_requests
    res = Resolution.new

    assert res.respond_to?(:payload_requests)
  end
  
  def test_resolution_has_width_attribute
    res = Resolution.new(width: "1920")

    assert_equal "1920", res.width
  end

  def test_resolution_has_height_attribute
    res = Resolution.new(height: "1280")

    assert_equal "1280", res.height
  end

  def test_resolution_create_w_valid_attributes
    res = Resolution.new(width: "1920", height: "1280")

    assert res.valid?
  end

  def test_resolution_not_create_w_invalid_attributes
    res = Resolution.new(width: "1920")

    refute res.valid?
  end

  def test_resolution_uniqueness
    res_one = Resolution.create(width: "1920", height: "1280")
    res_two = Resolution.create(width: "1920", height: "1280")

    assert res_one.valid?
    refute res_two.valid?
    assert_equal 1, Resolution.count
  end

  def test_resolution_uniqueness_relationship
    res_one = Resolution.create(width: "1920", height: "1280")
    res_two = Resolution.create(width: "2000", height: "1280")
    res_three = Resolution.create(width: "1920", height: "1350")

    assert res_one.valid?
    assert res_two.valid?
    assert res_three.valid?
    assert_equal 3, Resolution.count
  end

  def test_resolution_across_requests
    res_one = Resolution.create(width: "1920", height: "1280")
    res_two = Resolution.create(width: "2000", height: "1280")
    res_three = Resolution.create(width: "1920", height: "1350")

    fake_resolution_data(res_one.id, 2, 1)
    fake_resolution_data(res_two.id, 3, 5)
    fake_resolution_data(res_three.id, 4, 10)

    assert Resolution.resolution_dimensions_across_requests.any?{|v| v == "1920 x 1280"}
    assert Resolution.resolution_dimensions_across_requests.any?{|v| v == "2000 x 1280"}
    assert Resolution.resolution_dimensions_across_requests.any?{|v| v == "1920 x 1350"}
    assert_equal 3, Resolution.count
  end

  def fake_resolution_data(res_id, number, dummy)
    number.times do
      PayloadRequest.create(url_id: 1, requested_at: dummy += 1,
                            responded_in: dummy += 1, referrer_id: 1, request_type_id: 3,
                              user_agent_id: 1, resolution_id: res_id, ip_address_id: 2)
    end
  end
end
