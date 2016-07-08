class AddClientIdToPayloadTable < ActiveRecord::Migration
  def change
    add_column :payload_requests, :client_id, :text
  end
end
