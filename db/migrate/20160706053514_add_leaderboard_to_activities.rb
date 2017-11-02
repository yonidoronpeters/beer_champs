class AddLeaderboardToActivities < ActiveRecord::Migration[4.2]
  def change
    add_reference :activities, :leaderboard, index: true
    add_foreign_key :activities, :leaderboards
    add_index :activities, [:leaderboard_id, :created_at]
  end
end
