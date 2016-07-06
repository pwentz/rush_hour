class ChangeRequestedAtColumnToDate < ActiveRecord::Migration
  def change
    create_table :referrers do |t|
      t.text  :referrer
    end
  end
end
