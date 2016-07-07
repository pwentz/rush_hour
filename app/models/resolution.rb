class Resolution < ActiveRecord::Base
  has_many  :payload_requests
  validates :width, presence: true
  validates :height, presence: true

  def self.resolution_list
    Resolution.all.map { |i| "#{i.width} x #{i.height}"}.uniq
  end
end
