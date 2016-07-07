require_relative '../test_helper'

class UserAgentTest < Minitest::Test
  include TestHelpers

  def test_list_of_browsers_used
    create_payload
    create_multiple_payloads(3)

    assert_equal ["Chrome", "Chrome0", "Chrome1", "Chrome2"], UserAgent.browser_list
  end

  def test_list_of_operating_systems_used
    create_payload
    create_multiple_payloads(3)

    assert_equal ["OSX 10.8.2", "OSX 10.8.20", "OSX 10.8.21", "OSX 10.8.22"], UserAgent.operating_system_list
  end
end
