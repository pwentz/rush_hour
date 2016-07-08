class Referrer < ActiveRecord::Base
  has_many  :payload_requests
  has_many  :ip_addresses, through: :payload_requests
  has_many  :request_types, through: :payload_requests
  has_many  :resolutions, through: :payload_requests
  has_many  :urls, through: :payload_requests
  has_many  :user_agents, through: :payload_requests

  validates :referrer, presence: true
end
