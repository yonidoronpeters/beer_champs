class LeaderboardController < ApplicationController
  def index
    @athlete_url = "https://www.strava.com/athletes/"
    @activity_url= "https://www.strava.com/activities/"
    get_date

    @leaderboard = Leaderboard.get_leaderboard_for_day(@date)
    render 'no_beers' if @leaderboard.empty?
  end

  ####################################
  private

  def get_date
    begin
      @year  = params[:activities]['activities_date(1i)']
      @month = params[:activities]['activities_date(2i)']
      @day   = params[:activities]['activities_date(3i)']
      @date  = Date.parse(@year +'-'+ @month +'-'+ @day)
    rescue
      puts "Error parsing date"
      @date = Date.today
    end
  end

end
