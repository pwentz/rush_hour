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

    dummy_payload(:url_id, url_one.id, 2)
    dummy_payload(:url_id, url_three.id, 4)
    dummy_payload(:url_id, url_two.id, 3)

    assert_equal "http://jumpstartlab.com/store", Url.most_requested
    assert_equal "http://jumpstartlab.com/blog", Url.least_requested
    assert_equal "http://mysite.com/blog", Url.most_requested_to_least_requested.keys[1]
  end

  def test_response_time_stats_for_url
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")

    dummy_payload(:url_id, url_one.id, 5)

    assert_equal 40, url_one.payload_requests.max_response_time
    assert_equal 36, url_one.payload_requests.min_response_time
    assert_equal [40, 39, 38, 37, 36], url_one.payload_requests.ordered_response_times
    assert_equal 38, url_one.payload_requests.average_response_time
  end

  def test_http_verbs_for_url
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    rt = RequestType.create(method_name: "GET")
    rt_two = RequestType.create(method_name: "POST")
    dummy_payload(:request_type_id, rt.id)
    dummy_payload(:request_type_id, rt_two.id)

    assert_equal ["GET", "POST"], url_one.request_types.http_verbs
  end

  def test_top_referrers_per_url
    url_one = Url.create(root_url: "http://jumpstartlab.com", path: "/blog")
    ref_one = Referrer.create(referrer: "http://www.google.com")
    ref_two = Referrer.create(referrer: "http://www.turing.io")
    ref_three = Referrer.create(referrer: "http://www.bing.com")
    ref_four = Referrer.create(referrer: "http://www.jumpstartlab.com")
    dummy_payload(:referrer_id, ref_one.id, 2)
    dummy_payload(:referrer_id, ref_two.id, 3)
    dummy_payload(:referrer_id, ref_three.id, 4)
    dummy_payload(:referrer_id, ref_four.id)

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
    dummy_payload(:user_agent_id, ua_one.id, 2)
    dummy_payload(:user_agent_id, ua_two.id, 3)
    dummy_payload(:user_agent_id, ua_three.id, 4)
    dummy_payload(:user_agent_id, ua_four.id)

    assert_equal "OS X 10.8.2 Safari", url_one.user_agents.top_user_agents.first
    assert_equal "OS X 10.4.2 Firefox", url_one.user_agents.top_user_agents[1]
    assert_equal "OS X 10.8.2 Chrome", url_one.user_agents.top_user_agents.last
  end

end
