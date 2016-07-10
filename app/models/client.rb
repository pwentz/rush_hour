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
  end
end
