class RemoveActivitiesRefFromLeaderboards < ActiveRecord::Migration[5.1]
  def change
    remove_reference :leaderboards, :activity, index: true, foreign_key: true
  end
end
