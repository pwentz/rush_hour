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
      @client = Client.find_by(identifier: identifier)
      erb :stats
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @client = Client.find_by(identifier: identifier)
      @url = identifier + "/" + relative_path
      @relative_path = relative_path
      erb :url_stats
    end

    not_found do
      erb :error
    end
  end
end
