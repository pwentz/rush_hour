require_relative 'client_validator'

class Client < ActiveRecord::Base
  has_many  :payload_requests
  has_many  :ip_addresses,  through: :payload_requests
  has_many  :referrers,     through: :payload_requests
  has_many  :request_types, through: :payload_requests
  has_many  :resolutions,   through: :payload_requests
  has_many  :urls,          through: :payload_requests
  has_many  :user_agents,   through: :payload_requests

  validates :identifier,  presence: true, :uniqueness => {:scope => :root_url}
  validates :root_url,    presence: true, :uniqueness => {:scope => :identifier}

  class << self
    include ClientValidator

    def find_client(identifier)
      client = Client.find_by(identifier: identifier)
      if !client
        {:erb => :error, :message => "The client identifier specified does not match any in our records."}
      elsif client.payload_requests.empty?
        {:client => client, :erb => :error, :message => "No payload data has been received for this source."}
      else
        {:client => client, :erb => :stats}
      end
    end
  end

    def top_browser_across_requests
      payload_requests.most_frequent_list(:user_agent).first.first.browser
    end

    def top_operating_system_across_requests
      payload_requests.most_frequent_list(:user_agent).first.first.operating_system
    end

    def user_agent_breakdown_by_os
      payload_requests.most_frequent_list(:user_agent).map do |ua|
        ua.first.operating_system
      end
    end

    def user_agent_breakdown_by_browser
      payload_requests.most_frequent_list(:user_agent).map do |ua|
        ua.first.browser
      end
    end

end
