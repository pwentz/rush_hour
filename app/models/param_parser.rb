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

  def create_payload(params)
    payload = payload_parse(params)

    url         = Url.create(:root_url => format_url(payload["url"])[:root_url],
                             :path => format_url(payload["url"])[:path])
    rtype       = RequestType.create(method_name: payload["request_type"])
    resolution  = Resolution.create(width: payload["resolution_width"], height: payload["resolution_width"])
    referrer    = Referrer.create(referrer: payload["referred_by"])
    user_agent  = UserAgent.create(operating_system: user_agent(payload["user_agent"]).os,
                                   browser: user_agent(payload["user_agent"]).family)
    ip          = IPAddress.create(ip_address: payload["ip"])

    PayloadRequest.create(url_id: url.id,
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

  def user_agent(user_agent)
    UserAgentParser.parse(user_agent)
  end
end
