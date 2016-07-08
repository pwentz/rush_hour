module RushHour
  class Server < Sinatra::Base

    post '/sources' do
      client = Client.new(params[:client])
      if Client.find_by(:identifier => client.identifier)
        status 403
        body 'Client already exists!'
      elsif client.save
        body 'Client saved!'
      else
        status 400
        body 'Client not created'
      end
    end

    not_found do
      erb :error
    end
  end
end
