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

  def http_verbs
    payload_requests.map do |payload|
      RequestType.find(payload.request_type_id).method_name
    end.uniq
  end

  def top_referrers
    #AR .order or .where methods for refactoring
    Url.find(1).payload_requests.reduce({}) do |result, payload|
      result.merge!(Referrer.find(payload.referrer_id).referrer => 1) do |key, old, new|
        old + new
      end
    end.sort_by{|url, number| -number}[0..2].to_h
  end

  def top_user_agents
    require 'pry'; binding.pry
    #AR .order or .where methods for refactoring
    Url.find(1).payload_requests.reduce({}) do |result, payload|
      result.merge!(UserAgent.find(payload.user_agent_id).operating_system + " " +
                    UserAgent.find(payload.user_agent_id).browser => 1) do |key, old, new|
        old + new
      end
    end.sort_by{|url, number| -number}[0..2].to_h
  end
end
