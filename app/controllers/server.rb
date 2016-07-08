require_relative '../models/param_parser'

module RushHour
  class Server < Sinatra::Base
    include ParamParser
    # include ClientValidator

    post '/sources' do
      client = Client.find_or_create(camel_to_snake_case(params))
      if client
        status 403
        body client.errors.full_messages.join(", ")
      elsif client.save
        body 'Client saved!'
      else
        status 400
        body 'Client not created'
      end

      #
      # client_validator = ClientValidator.new( params)
      #
      # status client_validator[:status]
      # body client_validator[:message]


    end

    post '/sources/:identifier/data' do |identifier|
      require "pry"; binding.pry
      payload_request = PayloadRequest.new(create_payload(params))
    end

    not_found do
      erb :error
    end
  end
end
