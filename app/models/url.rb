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
    def validate_url(params)
      client = Client.find_by(identifier: params[:identifier])
      url = client.urls.where(path: "/" + params[:relative_path])
      if url.exists?
        {:url => url.uniq.first, :erb => :url_stats}
      else
        {:erb => :error, :message => "The url specified does not have any payload requests yet."}
      end
    end

  end

end
