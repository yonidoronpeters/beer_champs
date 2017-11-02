class LeaderboardController < ApplicationController
  def index
    @athlete_url = "https://www.strava.com/athletes/"
    @activity_url= "https://www.strava.com/activities/"
    @date = Date.parse(params[:activities_date]) rescue Date.today

    @leaderboard = Leaderboard.get_leaderboard_for_day(@date)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
