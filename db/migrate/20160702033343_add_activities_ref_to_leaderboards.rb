class AddActivitiesRefToLeaderboards < ActiveRecord::Migration
  def change
    add_reference :leaderboards, :activity, index: true
    add_foreign_key :leaderboards, :activities
  end
  add_index :leaderboards, :created_at
end
