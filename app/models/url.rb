class Url < ActiveRecord::Base
  has_many  :payload_requests
  has_many  :ip_addresses,  through: :payload_requests
  has_many  :referrers,     through: :payload_requests
  has_many  :request_types, through: :payload_requests
  has_many  :resolutions,   through: :payload_requests
  has_many  :user_agents,   through: :payload_requests

  validates :root_url,  presence: true, uniqueness: {:scope => :path}
  validates :path,      presence: true, uniqueness: {:scope => :root_url}

  class << self
    def most_requested_to_least_requested
      PayloadRequest.group(:url_id).count.reduce({}) do |result, url|
        result.merge!(Url.find(url.first).root_url + Url.find(url.first).path => url.last)
      end.sort_by{|k,v| -v }.to_h
    end

    def most_requested
      most_requested_to_least_requested.keys.first
    end

    def least_requested
      most_requested_to_least_requested.keys.last
    end

    def validate_url(params)
      client = Client.find_by(:identifier == params[:identifier])
      if client.urls.where(root_url: client.root_url, path: "#{/params["relative_path"]}").exists?
        {:client => client, :erb => :url_stats}
      else
        {:erb => :error, :message => ""}
      end
    end
  end

end
