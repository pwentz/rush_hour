class Url < ActiveRecord::Base
  has_many  :payload_requests
  has_many  :ip_addresses,  through: :payload_requests
  has_many  :referrers,     through: :payload_requests
  has_many  :request_types, through: :payload_requests
  has_many  :resolutions,   through: :payload_requests
  has_many  :user_agents,   through: :payload_requests

  validates :root_url,  presence: true, uniqueness: {:scope => :path}
  validates :path,      presence: true, uniqueness: {:scope => :root_url}

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
    request_types.pluck(:method_name).uniq
  end

  def top_referrers
    find_top_three(referrers, :referrer).keys
  end

  def top_user_agents
    # Url.find(1).payload_requests.reduce({}) do |result, payload|
    #   result.merge!(UserAgent.find(payload.user_agent_id).operating_system + " " +
    #                 UserAgent.find(payload.user_agent_id).browser => 1) do |key, old, new|
    #     old + new
    #   end
    # end.sort_by{|url, number| -number}[0..2].to_h
    require 'pry', binding.pry
    user_agents.group(:operating_system, :browser).count.sort_by { |k,v| -v }.to_h.keys
  end

  def find_top_three(table, attribute)
    table.group(attribute).count.sort_by { |k,v| -v }.to_h
  end
end
