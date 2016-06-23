class LeaderboardController < ApplicationController
  def index
    @client = Strava::Api::V3::Client.new(:access_token => ENV['STRAVA_TOKEN'])
    club_id = 202870

    club_activities = @client.list_club_activities(club_id)
    athletes_hash = filter_by_date(club_activities)

    @athletes = Leaderboard.calculate_beers_for_athletes(athletes_hash).keys.sort_by { |athlete| athlete.beers}.reverse
    render 'no_beers' if @athletes.empty?
  end


  ##################################################################

  private

    def filter_by_date(activities)
      athletes = Hash.new([])
      activities.each do |activity|
        if Date.parse(activity['start_date_local']).today?
          athlete = get_or_create_athlete(activity)
          full_activity = @client.retrieve_an_activity(activity['id'])
          if athletes[athlete].empty?
            athletes[athlete] = [full_activity]
          else
            athletes[athlete].push(full_activity)
          end
        end
      end
      athletes
    end

    def get_or_create_athlete(activity)
      id         = activity['athlete']['id']
      begin
        athlete  = Athlete.find(id)
      rescue
        username = activity['athlete']['username']
        name     = activity['athlete']['firstname'] + " " + activity['athlete']['lastname']
        img_url  = activity['athlete']['profile']
        athlete  = Athlete.create(name: name, img_url: img_url, id: id, username: username)
      end
      athlete
    end
end
