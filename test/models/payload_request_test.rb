require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers



  def test_no_object_creation_on_blank_fields
    attempt = PayloadRequest.create(url: "https:/akdjsakjsd/asd", requestedAt: "19394")
    refute attempt.valid?
  end

  def test_object_creation_on_valid_fields
    new_url = Url.create(root_url: "http://www.aksdnakj.com", path: "/yeah")
    attempt = PayloadRequest.create(requested_at: "indsakjdsa", responded_in: "dadnsa")
    new_url.payloads << attempt
    assert attempt.valid?
  end

  def test_payload_links_with_ip_table

  end
end
