require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers
  
  def test_ip_address_has_payloads
    create_payload

    assert_equal "http://jumpstartlab.com/", Url.all.first.root_url
    assert_equal "/blog", Url.all.first.path
  end
end
