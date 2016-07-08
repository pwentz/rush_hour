class UserAgent < ActiveRecord::Base
  has_many  :payload_requests

  validates :operating_system,  presence: true, uniqueness: {:scope => :browser}
  validates :browser,           presence: true, uniqueness: {:scope => :operating_system}

  def self.browser_list
      pluck(:browser)
  end

  def self.operating_system_list
      pluck(:operating_system)
  end
end
