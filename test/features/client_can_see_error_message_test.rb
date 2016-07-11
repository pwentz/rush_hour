require_relative '../test_helper'

class ClientCanSeeErrorMessageTest < FeatureTest
  include TestHelpers

  def setup
    client = Client.create(root_url: "http://jumpstartlab.com", identifier: "jumpstartlab")
    dummy_payload(:client_id, client.id, 4)
    url_create("http://jumpstartlab.com", "/blog")
    request_type_create("GET")
    resolution_create("1920", "1580")
    user_agent_create("OS X 10.8.2", "Chrome")
    referrer_create("www.google.com")
    ip_address_create("102.42.91.123")
  end

  def test_no_identifier_page_displays_nonexistent_identifier_message
    visit("/sources/turing")

    assert page.has_content?("The client identifier specified does not match any in our records.")
  end

  def test_no_payload_page_displays_nonexistent_payload_message
    client = Client.create(root_url: "http://gooogle.com", identifier: "gooogle")

    visit("/sources/gooogle")

    assert page.has_content?("No payload data has been received for this source.")
  end

  def test_no_url_page_displays_nonexistent_url_message
    visit("/sources/jumpstartlab/urls/fake")

    assert page.has_content?("The url specified does not have any payload requests yet.")
  end
end
