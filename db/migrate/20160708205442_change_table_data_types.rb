class ChangeTableDataTypes < ActiveRecord::Migration
  def change
    change_column :payload_requests, :url_id, 'integer USING CAST(url_id AS integer)'
    change_column :payload_requests, :referrer_id, 'integer USING CAST(referrer_id AS integer)'
    change_column :payload_requests, :request_type_id, 'integer USING CAST(request_type_id AS integer)'
    change_column :payload_requests, :user_agent_id, 'integer USING CAST(user_agent_id AS integer)'
    change_column :payload_requests, :resolution_id, 'integer USING CAST(resolution_id AS integer)'
    change_column :payload_requests, :ip_address_id, 'integer USING CAST(ip_address_id AS integer)'
    change_column :payload_requests, :client_id, 'integer USING CAST(client_id AS integer)'
  end
end
