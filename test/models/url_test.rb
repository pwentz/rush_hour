require_relative '../test_helper'

class UrlTest < Minitest::Test
  def test_ip_address_has_payloads
    payload = PayloadRequest.create(requested_at: "fsdfd", responded_in: "sdsa")
    url = Url.create(root_url: "http://www.aslds.com", path: "/hey")

    url.payload_requests << payload
    assert_equal "fsdfd", url.payload_requests.first.requested_at
  end
end
