class RequestType < ActiveRecord::Base

  has_many  :payload_requests
  has_many  :ip_addresses,  through: :payload_requests
  has_many  :referrers,     through: :payload_requests
  has_many  :resolutions,   through: :payload_requests
  has_many  :urls,          through: :payload_requests
  has_many  :user_agents,   through: :payload_requests

  validates :method_name, presence: true, uniqueness: true

  def self.most_frequent_request_type
    find(PayloadRequest.most_frequent(:request_type_id)).method_name
  end

  def self.http_verbs
    pluck(:method_name)
  end
end
