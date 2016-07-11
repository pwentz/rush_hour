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

  def test_user_agent_breakdown_across_requests
    valid_attributes = {identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"}
    client = Client.create(valid_attributes)
    ua_one = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Chrome")
    ua_two = UserAgent.create(operating_system: "OS X 10.4.2", browser: "Firefox")
    ua_three = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Safari")

    dummy_payload(:user_agent_id, ua_one.id)
    dummy_payload(:user_agent_id, ua_two.id, 3)
    dummy_payload(:user_agent_id, ua_three.id, 4)
    client.payload_requests << PayloadRequest.all

    assert_equal "Safari", client.top_browser_across_requests
    assert_equal "OS X 10.8.2", client.top_operating_system_across_requests
  end
end
