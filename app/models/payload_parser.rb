require 'user_agent_parser'
module PayloadParser

  def camel_to_snake_case(params)
    params.reduce({}) do |result, param|
      result.merge!(param.first.underscore => param.last)
    end
  end

  def payload_parse(params)
    camel_to_snake_case(JSON(params[:payload]))
  end


  def create_payload(params)
    payload = payload_parse(params)

    url         = Url.find_or_create_by(format_url(payload["url"]))
    rtype       = RequestType.find_or_create_by(method_name: payload["request_type"])
    resolution  = Resolution.find_or_create_by(width: payload["resolution_width"], height: payload["resolution_height"])
    referrer    = Referrer.find_or_create_by(referrer: payload["referred_by"])
    user_agent  = UserAgent.find_or_create_by(operating_system: user_agent_os(payload["user_agent"]), browser: user_agent_browser(payload["user_agent"]))
    ip          = IPAddress.find_or_create_by(ip_address: payload["ip"])

    PayloadRequest.new(url_id: url.id,
                          requested_at: payload["requested_at"],
                          responded_in: payload["responded_in"],
                          referrer_id: referrer.id,
                          request_type_id: rtype.id,
                          user_agent_id: user_agent.id,
                          resolution_id: resolution.id,
                          ip_address_id: ip.id)
  end

  def format_url(url)
    # refactor?
    {:root_url => split_url(url)[0..2].join("/"), :path => "/" + split_url(url).last}
  end

  def split_url(url)
    url.split("/")
  end

  def user_agent_browser(user_agent)
    UserAgentParser.parse(user_agent).family.to_s
  end

  def user_agent_os(user_agent)
    UserAgentParser.parse(user_agent).os.to_s
  end
end
