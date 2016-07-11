require_relative '../test_helper'

class ClientCanSeeSpecificUrlStatsTest < FeatureTest
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

  def test_client_can_click_specific_url
    visit '/sources/jumpstartlab'

    within("#statistics") do
      click_link("http://jumpstartlab.com/blog")
    end

    assert_equal "/sources/jumpstartlab/urls/blog", current_path
  end
end
