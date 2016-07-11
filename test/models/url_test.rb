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

  def test_response_time_stats_for_url
    url = url_create("http://jumpstartlab.com",  "/blog")

    dummy_payload(:url_id, url.id, 5)

    assert_equal 40, url.payload_requests.max_response_time
    assert_equal 36, url.payload_requests.min_response_time
    assert_equal [40, 39, 38, 37, 36], url.payload_requests.ordered_response_times
    assert_equal 38, url.payload_requests.average_response_time
  end

  def test_top_referrers_per_url
    url = url_create("http://jumpstartlab.com", "/blog")
    ref_one = referrer_create("http://www.google.com")
    ref_two = referrer_create("http://www.turing.io")
    ref_three = referrer_create("http://www.bing.com")
    ref_four = referrer_create("http://www.jumpstartlab.com")
    dummy_payload(:referrer_id, ref_one.id, 2)
    dummy_payload(:referrer_id, ref_two.id, 3)
    dummy_payload(:referrer_id, ref_three.id, 4)
    dummy_payload(:referrer_id, ref_four.id)

    assert_equal "http://www.bing.com", url.top_three_referrers.first
    assert_equal "http://www.turing.io", url.top_three_referrers[1]
    assert_equal "http://www.google.com", url.top_three_referrers.last
  end

  def test_top_three_user_agents_by_url
    url = url_create("http://jumpstartlab.com", "/blog")
    ua_one = user_agent_create("OS X 10.8.2", "Chrome")
    ua_two = user_agent_create("OS X 10.4.2", "Firefox")
    ua_three = user_agent_create("OS X 10.8.2", "Safari")
    ua_four = user_agent_create("OS X 8.8.2", "IE9")
    dummy_payload(:user_agent_id, ua_one.id, 2)
    dummy_payload(:user_agent_id, ua_two.id, 3)
    dummy_payload(:user_agent_id, ua_three.id, 4)
    dummy_payload(:user_agent_id, ua_four.id)

    assert_equal "OS X 10.8.2 Safari", url.top_three_user_agents.first
    assert_equal "OS X 10.4.2 Firefox", url.top_three_user_agents[1]
    assert_equal "OS X 10.8.2 Chrome", url.top_three_user_agents.last
  end

  def test_http_verbs_used
    url = url_create("http://jumpstartlab.com", "/blog")
    rt_one = request_type_create("GET")
    rt_two = request_type_create("POST")
    dummy_payload(:request_type_id, rt_one.id, 2)
    dummy_payload(:request_type_id, rt_two.id, 3)

    assert url.http_verbs.any?{|request_name| request_name == "GET"}
    assert url.http_verbs.any?{|request_name| request_name == "POST"}
    assert_equal 2, url.http_verbs.count
  end

end
