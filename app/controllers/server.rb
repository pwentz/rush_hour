require_relative '../models/param_parser'
require_relative '../models/client_validator'
require_relative '../models/payload_validator'

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

    post '/sources/:identifier/data' do |identifier|
      validate_payload
    end

    not_found do
      erb :error
    end
  end
end
