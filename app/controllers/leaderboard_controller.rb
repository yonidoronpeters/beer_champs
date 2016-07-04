class LeaderboardController < ApplicationController
  def index
    @athlete_url = "https://www.strava.com/athletes/"

    @leaderboard = Leaderboard.calc_todays_stats
    render 'no_beers' if @leaderboard.empty?
  end

end
