class UserAgent < ActiveRecord::Base
  has_many  :payload_requests
  validates :operating_system, presence: true
  validates :browser, presence: true

  def self.browser_list
      UserAgent.pluck(:browser).uniq
  end
  
  def self.operating_system_list
      UserAgent.pluck(:operating_system).uniq
  end
end
