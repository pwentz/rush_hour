require_relative '../test_helper'
class ServerTest < Minitest::Test
  include TestHelpers

  def test_client_post_request
    post '/sources', {:client => {:identifier => "jumpstartlab",
                                  :root_url => "http://jumpstartlab.com"}}

    assert_equal 200, last_response.status
    assert_equal 'Client saved!', last_response.body
    assert_equal 1, Client.count
  end

  def test_client_post_request_invalidate
    post '/sources', {:client => {:identifier => "jumpstartlab"}}
                                  

    assert_equal 400, last_response.status
    assert_equal 'Client not created', last_response.body
  end

  def test_client_post_request_exists
    post '/sources', {:client => {:identifier => "jumpstartlab",
                                  :root_url => "http://jumpstartlab.com"}}
    post '/sources', {:client => {:identifier => "jumpstartlab",
                                  :root_url => "http://jumpstartlab.com"}}
                                  

    assert_equal 403, last_response.status
    assert_equal 'Client already exists!', last_response.body
  end
end
