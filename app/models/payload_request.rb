class PayloadRequest < ActiveRecord::Base
  belongs_to  :ip_address
  belongs_to  :referrer
  belongs_to  :request_type
  belongs_to  :resolution
  belongs_to  :url
  belongs_to  :user_agent
  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :referrer_id, presence: true
  validates :request_type_id, presence: true
  validates :user_agent_id, presence: true
  validates :resolution_id, presence: true
  validates :ip_address_id, presence: true
end
