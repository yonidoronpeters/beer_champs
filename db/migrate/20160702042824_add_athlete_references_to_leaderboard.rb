class AddAthleteReferencesToLeaderboard < ActiveRecord::Migration[4.2]
  def change
    add_reference :leaderboards, :athlete, index: true
    add_foreign_key :leaderboards, :athletes
  end
end
