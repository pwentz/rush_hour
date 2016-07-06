class AdjustPayloadColumns < ActiveRecord::Migration
  def change
    rename_column :payload_requests, :url, :url_id
    rename_column :payload_requests, :referred_by, :referrer_id
    rename_column :payload_requests, :user_agent, :user_agent_id
    rename_column :payload_requests, :request_type, :request_type_id
    rename_column :payload_requests, :ip, :ip_address_id
    remove_column :payload_requests, :resolution_width
    rename_column :payload_requests, :resolution_height, :resolution_id
  end
end
