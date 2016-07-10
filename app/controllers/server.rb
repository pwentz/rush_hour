require_relative '../models/param_parser'
require_relative '../models/client_validator'
require_relative '../models/payload_validator'
require 'pry'

module RushHour
  class Server < Sinatra::Base
    include ParamParser
    include ClientValidator
    include PayloadValidator

    post '/sources' do
      client = validate_client
      status client[:status]
      body client[:body]
    end

    post '/sources/:identifier/data' do
      payload = validate_payload
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
