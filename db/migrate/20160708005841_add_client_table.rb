class AddClientTable < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.text  :root_url
    end
  end
end
