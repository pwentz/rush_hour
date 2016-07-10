require_relative 'payload_validator'
require_relative 'payload_parser'

class PayloadRequest < ActiveRecord::Base
  belongs_to  :client
  belongs_to  :ip_address
  belongs_to  :referrer
  belongs_to  :request_type
  belongs_to  :resolution
  belongs_to  :url
  belongs_to  :user_agent


  validates :requested_at, presence: true, uniqueness: {:scope => [:url_id, :ip_address_id, :referrer_id,
                                                                   :request_type_id, :resolution_id, :user_agent_id,
                                                                   :client_id]}
  validates :responded_in, presence: true

  class << self
    include PayloadValidator
    include PayloadParser

    def average_response_time
      average(:responded_in).to_i
    end

    def max_response_time
      maximum(:responded_in)
    end

    def min_response_time
      minimum(:responded_in)
    end

    def most_frequent(id)
      most_frequent_list(id).first.first
    end

    def most_frequent_list(id)
      group(id).order('count_id DESC').count(:id)
    end

    def ordered_response_times
      order(responded_in: :desc).pluck(:responded_in)
    end

    def requested_urls_in_descending_order
      most_frequent_list(:url_id).reduce({}) do |result, url|
        result.merge!(Url.find(url.first).root_url + Url.find(url.first).path => url.last)
      end.sort_by{|k,v| -v }.to_h
    end

    def top_requested_url
      requested_urls_in_descending_order.keys.first
    end

    def min_requested_url
      requested_urls_in_descending_order.keys.last
    end
  end

end
