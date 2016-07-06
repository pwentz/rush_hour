class PayloadRequest < ActiveRecord::Base
  belongs_to  :ip_address
  belongs_to  :referrer
  belongs_to  :request_type
  belongs_to  :resolution
  belongs_to  :url
  belongs_to  :user_agent
  validates :requested_at, presence: true
  validates :responded_in, presence: true
end
