require_relative '../test_helper'

class ClientTest < Minitest::Test
  include TestHelpers

  def test_client_has_relationship_with_payload
    # client = Client.create(root_url: 'http://jumpstartlab.com', identifier: 'jumpstartlab')
    # create_payload
    # client.payload_requests << PayloadRequest.find(1)
    #
    # assert_equal "http://jumpstartlab.com", Client.find(PayloadRequest.find(1).client_id).root_url
    # assert_equal "jumpstartlab", Client.find(PayloadRequest.find(1).client_id).identifier
    client = Client.new
    assert client.respond_to?(:payload_requests)
  end

  def test_client_has_an_identifier
    client = Client.new(identifier: "Turing")

    assert_equal "Turing", client.identifier
  end

  # def test_client_is_created_with_valid_attributes
  #
  #   valid_attributes = {...}
  #   client = Client.new(valid_attributes)
  #   assert client.valid?
  # end
end
