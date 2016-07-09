require_relative '../models/param_parser'
require_relative '../models/client_validator'

module RushHour
  class Server < Sinatra::Base
    include ParamParser
    include ClientValidator

    post '/sources' do
      client = validate_client
      status client[:status]
      body client[:body]
    end

    post '/sources/:identifier/data' do |identifier|
      payload_request = PayloadRequest.new(create_payload(params))
    end

    not_found do
      erb :error
    end
  end
end
