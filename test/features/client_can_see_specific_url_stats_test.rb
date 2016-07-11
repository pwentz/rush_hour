require_relative '../test_helper'

class ClientCanSeeSpecificUrlStatsTest < FeatureTest
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

  def test_url_specific_page_displays_url
    visit("/sources/jumpstartlab/urls/blog")

    assert page.has_content?("Statistics for http://jumpstartlab.com/blog")
  end

  def test_page_renders_with_css
    visit("/sources/jumpstartlab/urls/blog")

    assert page.has_css?("body")
  end

  def test_client_can_see_their_statistics
    visit '/sources/jumpstartlab/urls/blog'

    within("#statistics") do
      assert has_content?("Average Response Time")
      assert has_content?("37")
      assert has_content?("Maximum Response Time")
      assert has_content?("39")
      assert has_content?("Minimum Response Time")
      assert has_content?("36")
      assert has_content?("All HTTP Verbs")
      assert has_content?("GET")
      # assert has_content?("Response Times from Longest to Shortest")
      # assert has_content?("a")
      # assert has_content?("Top Three Referrers")
      assert has_content?("www.google.com")
      # assert has_content?("Top Three User Agents")
      assert has_content?("OS X 10.8.2 Chrome")
      # assert has_content?("Screen Resolution Breakdown")
      # assert has_content?("1920 x 1580")
    end
  end
end
