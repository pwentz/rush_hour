class Url < ActiveRecord::Base
  has_many  :payload_requests
  validates :root_url, presence: true
  validates :path, presence: true

  def self.most_requested_to_least_requested
    Url.all.reduce({}) do |result, url|
      result.merge!(url[:root_url] + url[:path] => 1) do |key, oldval, newval|
        oldval + newval
      end
    end.sort_by{|k,v| -v }.to_h
  end

  def average_response_time_per_site
    payload_requests.average_response_time
  end
end
