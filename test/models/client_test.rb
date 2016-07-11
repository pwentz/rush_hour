require_relative '../test_helper'

class ClientTest < Minitest::Test
  include TestHelpers

  def test_client_has_relationship_with_payload
    client = Client.new
    assert client.respond_to?(:payload_requests)
  end

  def test_client_has_an_identifier
    client = Client.new(identifier: "Turing")

    assert_equal "Turing", client.identifier
  end

  def test_client_has_a_root_url
    client = Client.new(root_url: "http://jumpstartlab.com")

    assert_equal "http://jumpstartlab.com", client.root_url
  end

  def test_client_is_created_with_valid_attributes
   valid_attributes = {identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"}
   client = Client.new(valid_attributes)
   assert client.valid?
  end

  def test_client_is_not_created_with_invalid_attributes
    invalid_attributes = {identifier: "jumpstartlab"}
    client = Client.new(invalid_attributes)
    refute client.valid?
  end

  def test_client_uniqueness
   valid_attributes = {identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"}
   client_one = Client.create(valid_attributes)
   client_two = Client.create(valid_attributes)

   assert client_one.valid?
   refute client_two.valid?
   assert_equal 1, Client.count
  end

  def test_browser_breakdown_across_requests
    client = client_create("jumpstartlab", "http://jumpstartlab.com")
    ua_one = user_agent_create("OS X 10.8.2", "Chrome")
    ua_two = user_agent_create("OS X 10.4.2", "Firefox")
    ua_three = user_agent_create("OS X 10.8.2", "Safari")

    dummy_payload(:user_agent_id, ua_one.id)
    dummy_payload(:user_agent_id, ua_two.id, 3)
    dummy_payload(:user_agent_id, ua_three.id, 4)
    client_to_payloads(client)

    assert client.browsers.any?{|browser| browser == "Chrome"}
    assert client.browsers.any?{|browser| browser == "Safari"}
    assert client.browsers.any?{|browser| browser == "Firefox"}
    assert_equal 3, client.browsers.count
  end

  def test_operating_system_breakdown_across_requests
    client = client_create("jumpstartlab", "http://jumpstartlab.com")
    ua_one = user_agent_create("OS X 10.8.2", "Chrome")
    ua_two = user_agent_create("OS X 10.4.2", "Firefox")
    ua_three = user_agent_create("OS X 10.8.2", "Safari")

    dummy_payload(:user_agent_id, ua_one.id)
    dummy_payload(:user_agent_id, ua_two.id, 3)
    dummy_payload(:user_agent_id, ua_three.id, 4)
    client_to_payloads(client)


    assert client.operating_systems.any?{|browser| browser == "OS X 10.8.2"}
    assert client.operating_systems.any?{|browser| browser == "OS X 10.4.2"}
    assert_equal 2, client.operating_systems.count
  end

  def test_find_most_frequent_response_type
    client = client_create("jumpstartlab", "http://jumpstartlab.com")
    rt_one = request_type_create("GET")
    rt_two = request_type_create("POST")
    dummy_payload(:request_type_id, rt_one.id, 3)
    dummy_payload(:request_type_id, rt_two.id, 5)
    client_to_payloads(client)

    assert_equal "POST", client.most_frequent_request_type
  end

  def test_all_http_verbs_used
    client = client_create("jumpstartlab", "http://jumpstartlab.com")
    rt_one = request_type_create("GET")
    rt_two = request_type_create("POST")
    dummy_payload(:request_type_id, rt_one.id, 3)
    dummy_payload(:request_type_id, rt_two.id, 2)
    client_to_payloads(client)

    assert client.all_http_verbs.any?{|verb| verb == "POST"}
    assert client.all_http_verbs.any?{|verb| verb == "GET"}
    assert_equal 2, client.all_http_verbs.count
  end

  def test_most_requested_urls
    client = client_create("jumpstartlab", "http://jumpstartlab.com")
    url_one = url_create("http://jumpstartlab.com", "/blog")
    url_two = url_create("http://jumpstartlab.com", "/store")
    url_three = url_create("http://jumpstartlab.com", "/about")
    dummy_payload(:url_id, url_one.id)
    dummy_payload(:url_id, url_two.id, 2)
    dummy_payload(:url_id, url_three.id, 3)
    client_to_payloads(client)

    assert_equal url_three, client.most_requested_urls.first
    assert_equal url_two, client.most_requested_urls[1]
    assert_equal url_one, client.most_requested_urls.last
  end

  def test_resolution_across_requests
    client = client_create("jumpstartlab", "http://jumpstartlab.com")
    res_one = resolution_create("1920", "1280")
    res_two = resolution_create("2000", "1280")
    res_three = resolution_create("1920", "1350")
    dummy_payload(:resolution_id, res_one.id)
    dummy_payload(:resolution_id, res_two.id, 5)
    dummy_payload(:resolution_id, res_three.id, 7)
    client_to_payloads(client)

    assert client.dimensions.any?{|v| v == "1920 x 1280"}
    assert client.dimensions.any?{|v| v == "2000 x 1280"}
    assert client.dimensions.any?{|v| v == "1920 x 1350"}
    assert_equal 3, client.dimensions.count
  end

end
