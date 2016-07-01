class LeaderboardController < ApplicationController
  def index
    @client = Strava::Api::V3::Client.new(:access_token => ENV['STRAVA_TOKEN'])
    @club_id = 202870
    @athlete_url = "https://www.strava.com/athletes/"

    club_activities = @client.list_club_activities(@club_id)
    new_activities = create_activities(club_activities)

    unless new_activities.empty?
      Athlete.calc_new_totals_for_athletes(new_activities)
    end

    @totals = Leaderboard.calc_todays_stats
    render 'no_beers' if @totals.empty?
  end


  ##################################################################

  private

    def create_activities(activities)
      new_activities = Array.new
      activities.each do |activity|
        begin
          if Activity.find(activity['id'])
            next
          end
        rescue
          begin
            athlete       = get_or_create_athlete(activity['athlete'])
            full_activity = @client.retrieve_an_activity(activity['id'])
            calories      = Activity.calc_calories(full_activity)
            new_activity  = Activity.create(
                            id:                   full_activity['id'], name: full_activity['name'], distance: full_activity['distance'],
                            activity_type:        full_activity['type'], moving_time: full_activity['moving_time'],
                            total_elevation_gain: full_activity['total_elevation_gain'],
                            calories:             calories, start_lat: full_activity['start_latlng'][0],
                            start_long:           full_activity['start_latlng'][1], end_lat: full_activity['end_latlng'][0],
                            end_long:             full_activity['end_latlng'][1], kudos_count: full_activity['kudos_count'],
                            created_at:           full_activity['start_date'], athlete_id: athlete.id,
                            beers:                Activity.calc_beers(calories))
            new_activities.push(new_activity)
          rescue
             next
          end
        end
      end
      new_activities
    end

    def get_or_create_athlete(activity_athlete)
      id         = activity_athlete['id']
      begin
        athlete  = Athlete.find(id)
      rescue
        username = activity_athlete['username']
        name     = activity_athlete['firstname'] + " " + activity_athlete['lastname']
        img_url  = activity_athlete['profile']
        athlete  = Athlete.create(name: name, img_url: img_url, id: id, username: username, calories: 0.0, beers: 0.0)
      end
      athlete
    end
end
