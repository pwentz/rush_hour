#module ClientValidator
  #client = Client.find_or_create(camel_to_snake_case(params))
  #if client
    #body 'Client saved!'
  #elsif client.exists?
    #status 400
   # body 'Client not created'
  #else
  #  status 403
  #  body client.errors.full_messages.join(", ")
 # end

#end
