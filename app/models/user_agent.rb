class UserAgent < ActiveRecord::Base
  has_many  :payload_requests

  validates :operating_system,  presence: true, uniqueness: true
  validates :browser,           presence: true, uniqueness: true

  def self.browser_list
      pluck(:browser)
  end

  def self.operating_system_list
      pluck(:operating_system).uniq
  end
end
