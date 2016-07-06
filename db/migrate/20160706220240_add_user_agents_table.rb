class AddUserAgentsTable < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.text :operating_system
      t.text :browser
    end
  end
end
