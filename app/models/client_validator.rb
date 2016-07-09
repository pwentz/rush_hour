module ClientValidator

  def validate_client
   client = Client.new(camel_to_snake_case(params))
   if Client.exists?(identifier: client.identifier)
     { body: 'Client already exists', status: 403 }
   elsif client.save
     { body: "{identifier:" + client.identifier + "}", status: 200 }
   else
     { body: 'Client not created', status: 400 }
   end
  end

end
