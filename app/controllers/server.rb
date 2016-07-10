require 'pry'

module RushHour
  class Server < Sinatra::Base

    post '/sources' do
      client = Client.validate_client(params)
      status client[:status]
      body client[:body]
    end

    post '/sources/:identifier/data' do
      payload = PayloadRequest.validate_payload(params)
      status payload[:status]
      body payload[:body]
    end

    get '/sources/:identifier' do |identifier|
      client = Client.find_client(identifier)
      @client = client[:client]
      @message = client[:message]
      erb client[:erb]
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      url = Url.validate_url(params)
      @url = url[:url]
      @message = url[:message]
      erb url[:erb]
    end

    not_found do
      @message = "Page not found." 
      erb :error
    end
  end
end
