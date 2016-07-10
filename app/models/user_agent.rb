class UserAgent < ActiveRecord::Base
  has_many  :payload_requests
  has_many  :ip_addresses,  through: :payload_requests
  has_many  :referrers,     through: :payload_requests
  has_many  :request_types, through: :payload_requests
  has_many  :resolutions,   through: :payload_requests
  has_many  :urls,          through: :payload_requests

  validates :operating_system,  presence: true, uniqueness: {:scope => :browser}
  validates :browser,           presence: true, uniqueness: {:scope => :operating_system}

  class << self
    def browser_list
        pluck(:browser)
    end

    def operating_system_list
        pluck(:operating_system)
    end

    def user_agents_across_requests
      PayloadRequest.group(:user_agent).count.sort_by{|k,v| -v}.to_h
    end

    def user_agent_breakdown_by_browser
      user_agents_across_requests.reduce({}) do |result, user_agent_breakdown|
        result.merge!(user_agent_breakdown.first.browser => user_agent_breakdown.last)
      end
    end

    def user_agent_breakdown_by_os
      user_agents_across_requests.reduce({}) do |result, user_agent_breakdown|
        result.merge!(user_agent_breakdown.first.operating_system => user_agent_breakdown.last)
      end
    end

    def top_browser_across_requests
      user_agent_breakdown_by_browser.first.first
    end

    def top_os_across_requests
      user_agent_breakdown_by_os.first.first
    end

    def top_user_agents
      user_agents_across_requests.reduce({}) do |result, ua|
        result.merge!("#{ua.first.operating_system} #{ua.first.browser}" => ua.last)
      end.keys.first(3)
    end
  end

end
