module PayloadValidator
  def validate_payload
    unless params.has_key?("payload")
      status 400
      body "Bad Request, missing payload"
    else
      sort_payload
    end
  end

  def sort_payload
    payload = create_payload(params)
    if PayloadRequest.where(requested_at: payload.requested_at,
                            url_id: payload.url_id).exists?
      status 403
      body "Already received payload request"
    elsif !Client.exists?(identifier: params["identifier"])
      status 403
      body "Application is not yet registered"
    else
      client = Client.find_by(identifier: params["identifier"])
      payload.save
      status 200
      body "Payload saved!"
    end
  end
end
