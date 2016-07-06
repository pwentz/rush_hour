class PayloadRequest < ActiveRecord::Base
  belongs_to  :ip_address
  belongs_to  :referrer
  belongs_to  :request_type
  belongs_to  :resolution
  belongs_to  :url
  belongs_to  :user_agent
  validates :url, presence: true
  validates :requestedAt, presence: true
  validates :respondedIn, presence: true
  validates :referredBy, presence: true
  validates :requestType, presence: true
  validates :userAgent, presence: true
  validates :resolutionWidth, presence: true
  validates :resolutionHeight, presence: true
  validates :ip, presence: true
end
