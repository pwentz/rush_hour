require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_url_have_relationship_with_payload_requests
    url = Url.new

    assert url.respond_to?(:payload_requests)
  end

  def test_url_has_root_url_attribute
    url = Url.new(root_url: "http://jumpstartlab.com")

    assert_equal "http://jumpstartlab.com", url.root_url
  end

  def test_url_has_path_attribute
    url = Url.new(path: "/blog")

    assert_equal "/blog", url.path
  end

  def test_url_created_w_valid_attributes
    url = Url.new(root_url: "http://jumpstartlab.com", path: "/blog")

    assert url.valid?
  end

  def test_url_not_created_w_invalid_attributes
    url = Url.new(path: "/blog")

    refute url.valid?
  end

  def test_url_uniqueness

    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    url_two = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")

    assert url_one.valid?
    refute url_two.valid?
    assert_equal 1, Url.count
  end

  def test_url_uniqueness_relationship
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    url_two = Url.create(root_url: "http://mysite.com", path: "/blog")
    url_three = Url.create(root_url: "http://jumpstartlab.com", path: "/store")

    assert url_one.valid?
    assert url_two.valid?
    assert url_three.valid?
    assert_equal 3, Url.count
  end

  def test_requested_url_breakdown_descending_order
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    url_two = Url.create(root_url: "http://mysite.com", path: "/blog")
    url_three = Url.create(root_url: "http://jumpstartlab.com", path: "/store")

    fake_url_data(url_one.id, 2)
    fake_url_data(url_three.id, 4)
    fake_url_data(url_two.id, 3)

    assert_equal "http://jumpstartlab.com/store", Url.most_requested
    assert_equal "http://jumpstartlab.com/blog", Url.least_requested
    assert_equal "http://mysite.com/blog", Url.most_requested_to_least_requested.keys[1]
  end

  def test_response_time_stats_for_url
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")

    fake_url_data(url_one.id, 4)

    assert_equal 40, url_one.payload_requests.max_response_time
    assert_equal 37, url_one.payload_requests.min_response_time
    assert_equal [40, 39, 38, 37], url_one.payload_requests.ordered_response_times
    assert_equal 38.5, url_one.payload_requests.average_response_time
  end

  def test_http_verbs_for_url
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    rt = RequestType.create(method_name: "GET")
    rt_two = RequestType.create(method_name: "POST")
    PayloadRequest.create(url_id: url_one.id, requested_at: 10,
                            responded_in: 5, referrer_id: 1, request_type_id: rt.id,
                              user_agent_id: 1, resolution_id: 1, ip_address_id: 2)
    PayloadRequest.create(url_id: url_one.id, requested_at: 11,
                            responded_in: 7, referrer_id: 1, request_type_id: rt_two.id,
                              user_agent_id: 1, resolution_id: 1, ip_address_id: 2)

    assert_equal ["GET", "POST"], url_one.request_types.http_verbs
  end

  def test_top_referrers_per_url
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    ref_one = Referrer.create(referrer: "http://www.google.com")
    ref_two = Referrer.create(referrer: "http://www.turing.io")
    ref_three = Referrer.create(referrer: "http://www.bing.com")
    ref_four = Referrer.create(referrer: "http://www.jumpstartlab.com")
    dummy = 5
    2.times do
      PayloadRequest.create(url_id: url_one.id, requested_at: dummy += 1,
                            responded_in: (35 + dummy += 1), referrer_id: ref_one.id, request_type_id: 3,
                              user_agent_id: 1, resolution_id: 1, ip_address_id: 2)
    end
    dummy = 10
    3.times do
      PayloadRequest.create(url_id: url_one.id, requested_at: dummy += 1,
                            responded_in: (35 + dummy), referrer_id: ref_two.id, request_type_id: 3,
                              user_agent_id: 1, resolution_id: 1, ip_address_id: 2)
    end
    dummy = 20
    4.times do
      PayloadRequest.create(url_id: url_one.id, requested_at: dummy += 1,
                            responded_in: (35 + dummy), referrer_id: ref_three.id, request_type_id: 3,
                              user_agent_id: 1, resolution_id: 1, ip_address_id: 2)
    end
    dummy = 50
    PayloadRequest.create(url_id: url_one.id, requested_at: dummy,
                          responded_in: (35 + dummy), referrer_id: ref_four.id, request_type_id: 3,
                            user_agent_id: 1, resolution_id: 1, ip_address_id: 2)

    assert_equal "http://www.bing.com", url_one.referrers.top_referrers.first
    assert_equal "http://www.turing.io", url_one.referrers.top_referrers[1]
    assert_equal "http://www.jumpstartlab.com", url_one.referrers.top_referrers.last
  end

  def test_top_three_user_agents_by_url
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    ua_one = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Chrome")
    ua_two = UserAgent.create(operating_system: "OS X 10.4.2", browser: "Firefox")
    ua_three = UserAgent.create(operating_system: "OS X 10.8.2", browser: "Safari")
    ua_four = UserAgent.create(operating_system: "OS X 8.8.2", browser: "IE9")

    dummy = 5
    2.times do
      PayloadRequest.create(url_id: url_one.id, requested_at: dummy += 1,
                            responded_in: (35 + dummy += 1), referrer_id: 1, request_type_id: 3,
                              user_agent_id: ua_one.id, resolution_id: 1, ip_address_id: 2)
    end
    dummy = 10
    3.times do
      PayloadRequest.create(url_id: url_one.id, requested_at: dummy += 1,
                            responded_in: (35 + dummy), referrer_id: 1, request_type_id: 3,
                              user_agent_id: ua_two.id, resolution_id: 1, ip_address_id: 2)
    end
    dummy = 20
    4.times do
      PayloadRequest.create(url_id: url_one.id, requested_at: dummy += 1,
                            responded_in: (35 + dummy), referrer_id: 1, request_type_id: 3,
                              user_agent_id: ua_three.id, resolution_id: 1, ip_address_id: 2)
    end
    dummy = 50
    PayloadRequest.create(url_id: url_one.id, requested_at: dummy,
                          responded_in: (35 + dummy), referrer_id: 1, request_type_id: 3,
                            user_agent_id: ua_four.id, resolution_id: 1, ip_address_id: 2)

    assert_equal "OS X 10.8.2 Safari", url_one.user_agents.top_user_agents.first
    assert_equal "OS X 10.4.2 Firefox", url_one.user_agents.top_user_agents[1]
    assert_equal "OS X 10.8.2 Chrome", url_one.user_agents.top_user_agents.last
  end

  def fake_url_data(url_id, number)
    dummy = 1
    number.times do
      dummy += 1
      PayloadRequest.create(url_id: url_id, requested_at: dummy,
                            responded_in: (35 + dummy), referrer_id: 1, request_type_id: 3,
                              user_agent_id: 1, resolution_id: 1, ip_address_id: 2)
    end
  end

  def test_returns_list_of_urls_ordered_by_descending_frequency
    skip
    Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    Url.create(root_url: "http://mysite.com", path: "/blog")
    Url.create(root_url: "http://jumpstartlab.com", path: "/store")
    PayloadRequest.create(url_id: 1, requested_at: "2012-02-16 21:38:28 -0800",
                            responded_in: 35, referrer_id: 1, request_type_id: 3,
                            user_agent_id: 1, resolution_id: 2, ip_address_id: 2)
    PayloadRequest.create(url_id: 2, requested_at: "2012-02-16 21:38:28 -0900",
                            responded_in: 35, referrer_id: 2, request_type_id: 2,
                            user_agent_id: 2, resolution_id: 3, ip_address_id: 2)
    PayloadRequest.create(url_id: 3, requested_at: "2012-02-16 21:38:28 -1000",
                            responded_in: 35, referrer_id: 3, request_type_id: 3,
                            user_agent_id: 3, resolution_id: 3, ip_address_id: 3)
    PayloadRequest.create(url_id: 1, requested_at: "2012-02-16 21:38:28 -0700",
                            responded_in: 35, referrer_id: 1, request_type_id: 1,
                            user_agent_id: 1, resolution_id: 1, ip_address_id: 1)
                            

    assert_equal "", Url.most_requested_to_least_requested
  end
end
