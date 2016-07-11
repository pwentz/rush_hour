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

    def browsers
      payload_requests.most_frequent_list(:user_agent).keys.map(&:browser).uniq
    end

    def operating_systems
      payload_requests.most_frequent_list(:user_agent).keys.map(&:operating_system).uniq
    end

    def most_frequent_request_type
      payload_requests.most_frequent(:request_type).method_name
    end

    def all_http_verbs
      payload_requests.most_frequent_list(:request_type).keys.map(&:method_name).uniq
    end

    def most_requested_urls
      payload_requests.most_frequent_list(:url).keys
    end

    def dimensions
      payload_requests.most_frequent_list(:resolution).keys.map do |resolution|
        "#{resolution.width} x #{resolution.height}"
      end
    end
end
