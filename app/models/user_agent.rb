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
        pluck(:browser).uniq
    end

    def operating_system_list
        pluck(:operating_system).uniq
    end

    def user_agents_across_requests
      all.group(:id).count.reduce({}) do |result, user_agent|
        result.merge!(find(user_agent.first) => user_agent.last)
      end.sort_by{|k,v| -v}
    end

    #URL SPECIFIC?
    def top_user_agents
      user_agents_across_requests.reduce({}) do |result, ua|
        result.merge!("#{ua.first.operating_system} #{ua.first.browser}" => ua.last)
      end.keys.first(3)
    end
  end

end
