require_relative '../test_helper'

class UserAgentTest < Minitest::Test
  include TestHelpers

  def test_user_agent_has_relationship_with_payload_requests
    ua = UserAgent.new

    assert ua.respond_to?(:payload_requests)
  end

  def test_user_agent_has_operating_system_attribute
    ua = UserAgent.new(operating_system: "OS X 10.8.2")

    assert_equal "OS X 10.8.2", ua.operating_system
  end

  def test_user_agent_has_browser_attribute
    ua = UserAgent.new(browser: "Chrome")

    assert_equal "Chrome", ua.browser
  end 

  def test_user_agent_created_with_valid_attributes
    ua = UserAgent.new(operating_system: "OS X 10.8.2", browser: "Chrome")

    assert ua.valid?
  end

  def test_user_agent_is_not_created_with_invalid_attributes
    ua = UserAgent.new(operating_system: "OS X 10.8.2")

    refute ua.valid?
  end

  def test_user_agent_uniqueness
    ua_one = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Chrome")
    ua_two = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Chrome")

    assert ua_one.valid?
    refute ua_two.valid?
    assert_equal 1, UserAgent.count
  end

  def test_user_agent_breakdown_across_requests
    ua_one = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Chrome")
    ua_two = UserAgent.create(operating_system: "OS X 10.4.2", browser: "Firefox")
    ua_three = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Safari")

    fake_ua_data(ua_one.id, 2, 1)
    fake_ua_data(ua_two.id, 3, 5)
    fake_ua_data(ua_three.id, 4, 10)

    assert_equal "Safari", UserAgent.top_browser_across_requests
    assert_equal "OS X 10.8.2", UserAgent.top_os_across_requests
  end

  def fake_ua_data(ua_id, number, dummy)
    number.times do
      PayloadRequest.create(url_id: 1, requested_at: dummy += 1,
                            responded_in: dummy += 1, referrer_id: 1, request_type_id: 3,
                              user_agent_id: ua_id, resolution_id: 1, ip_address_id: 2)
    end
  end
end
