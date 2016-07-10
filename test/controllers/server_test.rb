require_relative '../test_helper'
class ServerTest < Minitest::Test
  include TestHelpers


  def test_client_post_request
    params = 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'

    post '/sources', params

    assert_equal 200, last_response.status
    assert_equal '{"identifier":"jumpstartlab"}', last_response.body
    assert_equal 1, Client.count
  end

  def test_client_post_request_invalid_when_sent_without_root_url
    params = 'identifier=jumpstartlab'

    post '/sources', params


    assert_equal 400, last_response.status
    assert_equal 'Client not created', last_response.body
  end

  def test_duplicate_client_post_request_returns_errors
    params = 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'

    post '/sources', params

    post '/sources', params



    assert_equal 403, last_response.status
    assert_equal 'Client already exists', last_response.body
  end
  
  def test_client_cant_post_without_payload
    params = 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'

    post '/sources/jumpstartlab/data', params

    assert_equal 400, last_response.status
    assert_equal 'Bad Request, missing payload', last_response.body
  end

  def test_client_cant_send_duplicate_payloads
    client = 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'

    post '/sources', client

    params = 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    post '/sources/jumpstartlab/data',params
    post '/sources/jumpstartlab/data', params

    assert_equal 403, last_response.status
    assert_equal 'Already received payload request', last_response.body
  end

  def test_client_cant_post_without_registering
    params = 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    post '/sources/jumpstartlab/data', params

    assert_equal 403, last_response.status
    assert_equal "Application is not yet registered", last_response.body
  end

  def test_client_can_post_unique_payload_after_registering
    client = 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'

    post '/sources', client

    params = 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    post '/sources/jumpstartlab/data',params

    require 'pry'; binding.pry
    assert_equal 200, last_response.status
    assert_equal "Payload saved!", last_response.body
  end
end
