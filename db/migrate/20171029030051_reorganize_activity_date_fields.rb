class ReorganizeActivityDateFields < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :start_date_only, :date
    add_column :activities, :start_time, :datetime
    add_column :leaderboards, :activity_date_local, :date, index: true
    add_index :leaderboards, [:athlete_id, :activity_date_local]
  end
end
