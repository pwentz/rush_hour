class UserAgent < ActiveRecord::Base
  has_many  :payload_requests
  validates :operating_system, presence: true
  validates :browser, presence: true
end
