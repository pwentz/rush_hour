class PayloadRequest < ActiveRecord::Base
  belongs_to  :client
  belongs_to  :ip_address
  belongs_to  :referrer
  belongs_to  :request_type
  belongs_to  :resolution
  belongs_to  :url
  belongs_to  :user_agent


  validates :requested_at, presence: true, uniqueness: true
  validates :responded_in, presence: true

  def self.average_response_time
    average(:responded_in).to_i
  end

  def self.max_response_time
    maximum(:responded_in)
  end

  def self.min_response_time
    minimum(:responded_in)
  end
end
