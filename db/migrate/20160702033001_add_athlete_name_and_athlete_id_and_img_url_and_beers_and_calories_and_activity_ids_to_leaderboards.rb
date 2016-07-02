class AddAthleteNameAndAthleteIdAndImgUrlAndBeersAndCaloriesAndActivityIdsToLeaderboards < ActiveRecord::Migration
  def change
    add_column :leaderboards, :athlete_name, :string
    add_column :leaderboards, :img_url, :string
    add_column :leaderboards, :beers, :decimal
    add_column :leaderboards, :calories, :integer
  end
end
