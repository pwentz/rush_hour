class Url < ActiveRecord::Base
  has_many  :payload_requests

  validates :root_url, presence: true
  validates :path, presence: true

  def self.most_requested_to_least_requested
    all.reduce({}) do |result, url|
      result.merge!(url[:root_url] + url[:path] => 1) do |key, oldval, newval|
        oldval + newval
      end
    end.sort_by{|k,v| -v }.to_h
  end

  def average_response_time
    payload_requests.average_response_time
  end

  def max_response_time
    payload_requests.max_response_time
  end

  def min_response_time
    payload_requests.min_response_time
  end

  def ordered_response_times
    payload_requests.order(responded_in: :desc).pluck(:responded_in)
  end

  # def http_verbs
  #   binding.pry
  # end
end
