class RequestType < ActiveRecord::Base

  has_many  :payload_requests
  has_many  :ip_addresses, through: :payload_requests
  has_many  :referrers, through: :payload_requests
  has_many  :resolutions, through: :payload_requests
  has_many  :urls, through: :payload_requests
  has_many  :user_agents, through: :payload_requests

  validates :method_name, presence: true

  def self.most_frequent_request_type
    group(:method_name).count.max_by{|k,v| v}.first
  end

  def self.http_verbs
    uniq.pluck(:method_name)
  end
end
