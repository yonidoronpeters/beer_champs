class CreateActivities < ActiveRecord::Migration[4.2]
  def change
    create_table :activities do |t|
      t.string :name
      t.float :distance
      t.string :type
      t.integer :moving_time
      t.float :total_elevation_gain
      t.integer :calories
      t.float :start_lat
      t.float :start_long
      t.float :end_lat
      t.float :end_long
      t.integer :kudos_count

      t.timestamps null: false
    end
  end
end
