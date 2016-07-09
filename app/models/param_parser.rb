require 'user_agent_parser'
module ParamParser

  def camel_to_snake_case(params)
    params.reduce({}) do |result, param|
      result.merge!(param.first.underscore => param.last)
    end
  end

  def payload_parse(params)
    camel_to_snake_case(JSON(params[:payload]))
  end

  def client_parse(params)
  end

  def create_payload(params)
    payload = payload_parse(params)

    url         = Url.find_or_create_by(split_url(payload[:url]))
    rtype       = RequestType.find_or_create_by(method_name: "GET")
    resolution  = Resolution.find_or_create_by(width: "1920", height: "1280")
    referrer    = Referrer.find_or_create_by(referrer: "http://jumpstartlab.com")
    user_agent  = UserAgent.find_or_create_by(operating_system: "OSX 10.8.2", browser: "Chrome")
    ip          = IPAddress.find_or_create_by(ip_address: "63.29.38.211")

    PayloadRequest.find_or_create_by(url_id: url.id,
                          requested_at: "abcd",
                          responded_in: "5",
                          referrer_id: referrer.id,
                          request_type_id: rtype.id,
                          user_agent_id: user_agent.id,
                          resolution_id: resolution.id,
                          ip_address_id: ip.id)
    require 'pry'; binding.pry
  end

  def format_url(url)
    # refactor?
    {:root_url => split_url(url)[0..2].join("/"), :path => "/" + split_url(url).last}
  end

  def split_url(url)
    url.split("/")
  end

  def user_agent(user_agent)
    UserAgentParser.parse(user_agent)
  end
end
