module PayloadValidator
  def validate_payload(params)
    unless params.has_key?("payload")
      { status: 400,
        body: "Bad Request, missing payload" }
    else
      sort_payload(params)
    end
  end

  def sort_payload(params)
    payload = create_payload(params)
    if PayloadRequest.where(requested_at: payload.requested_at,
                            url_id: payload.url_id).exists?
      { status: 403,
        body: "Already received payload request" }
    elsif !Client.exists?(identifier: params["identifier"])
      { status: 403,
        body: "Application is not yet registered" }
    else
      client = Client.find_by(identifier: params["identifier"])
      payload.save
      client.payload_requests << payload
      { status: 200,
        body: "Payload saved!" }
    end
  end
end
