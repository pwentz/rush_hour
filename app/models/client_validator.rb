module ClientValidator

  def validate_client(params)
   client = Client.new(parse_client_request(params))
   if Client.exists?(identifier: client.identifier)
     { body: 'Client already exists', status: 403 }
   elsif client.save
     { body: {"identifier": "#{client.identifier}"}.to_json, status: 200 }
   else
     { body: 'Client not created', status: 400 }
   end
  end

  def parse_client_request(params)
    {identifier: params[:identifier], root_url: params[:rootUrl]}
  end

end
