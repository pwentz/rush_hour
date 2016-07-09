require_relative '../test_helper'
class ServerTest < Minitest::Test
  include TestHelpers


  def test_client_post_request
    identifier = "{identifier:jumpstartlab}"

    params = {"identifier"=>"jumpstartlab", "rootUrl"=>"http://jumpstartlab.com"}

    post '/sources', params

    assert_equal 200, last_response.status
    assert_equal identifier, last_response.body
    assert_equal 1, Client.count
  end

  def test_client_post_request_invalid_when_sent_without_root_url
    params = {"identifier"=>"jumpstartlab"}
                      
    post '/sources', params


    assert_equal 400, last_response.status
    assert_equal 'Client not created', last_response.body
  end

  def test_duplicate_client_post_request_returns_errors
    params = {"identifier"=>"jumpstartlab", "rootUrl"=>"http://jumpstartlab.com"}

    post '/sources', params
                    
    post '/sources', params



    assert_equal 403, last_response.status
    assert_equal 'Client already exists', last_response.body
  end
end
