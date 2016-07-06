class AddRequestTypeTable < ActiveRecord::Migration
  def change
    create_table :request_types do |t|
      t.text  :method_name
    end
  end
end
