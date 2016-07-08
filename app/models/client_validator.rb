module ClientValidator

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

end
