class Referrer < ActiveRecord::Base
  has_many  :payload_requests
  has_many  :ip_addresses,  through: :payload_requests
  has_many  :request_types, through: :payload_requests
  has_many  :resolutions,   through: :payload_requests
  has_many  :urls,          through: :payload_requests
  has_many  :user_agents,   through: :payload_requests

  validates :referrer, presence: true, uniqueness: true

  class << self
    def top_referrers
      find_top_three(:referrer).keys.first(3)
    end

    def find_top_three(attribute)
      group(attribute).count.sort_by { |k,v| -v }.to_h
    end
  end

end
