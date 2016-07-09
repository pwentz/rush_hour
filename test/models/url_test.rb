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
end
