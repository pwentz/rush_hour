class RequestType < ActiveRecord::Base
  has_many  :payload_requests
  validates :method_name, presence: true
end
