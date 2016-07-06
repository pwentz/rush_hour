class Referrer < ActiveRecord::Base
  has_many  :payload_requests
  validates :referrer, presence: true
end
