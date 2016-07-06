class ChangeToSnakecase < ActiveRecord::Migration
  def change
    rename_column :payload_requests, :requestedAt, :requested_at
    rename_column :payload_requests, :respondedIn, :responded_in
    rename_column :payload_requests, :referredBy, :referred_by
    rename_column :payload_requests, :requestType, :request_type
    rename_column :payload_requests, :userAgent, :user_agent
    rename_column :payload_requests, :resolutionWidth, :resolution_width
    rename_column :payload_requests, :resolutionHeight, :resolution_height
  end
end
