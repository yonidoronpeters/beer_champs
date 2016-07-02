class AddAthleteReferencesToLeaderboard < ActiveRecord::Migration
  def change
    add_reference :leaderboards, :athlete, index: true
    add_foreign_key :leaderboards, :athletes
  end
end
