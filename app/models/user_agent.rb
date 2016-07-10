class UserAgent < ActiveRecord::Base
  has_many  :payload_requests
  has_many  :ip_addresses,  through: :payload_requests
  has_many  :referrers,     through: :payload_requests
  has_many  :request_types, through: :payload_requests
  has_many  :resolutions,   through: :payload_requests
  has_many  :urls,          through: :payload_requests

  validates :operating_system,  presence: true, uniqueness: {:scope => :browser}
  validates :browser,           presence: true, uniqueness: {:scope => :operating_system}

  def self.browser_list
      pluck(:browser)
  end

  def self.operating_system_list
      pluck(:operating_system)
  end

  def self.most_frequent
  end

  def self.user_agents_across_requests
    PayloadRequest.group(:user_agent).count.sort_by{|k,v| -v}.to_h
  end

  def self.user_agent_breakdown_by_browser
    user_agents_across_requests.reduce({}) do |result, user_agent_breakdown|
      result.merge!(user_agent_breakdown.first.browser => user_agent_breakdown.last)
    end
  end

  def self.user_agent_breakdown_by_os
    user_agents_across_requests.reduce({}) do |result, user_agent_breakdown|
      result.merge!(user_agent_breakdown.first.operating_system => user_agent_breakdown.last)
    end
  end

  def self.top_browser_across_requests
    user_agent_breakdown_by_browser.first.first
  end

  def self.top_os_across_requests
    user_agent_breakdown_by_os.first.first
  end

end
