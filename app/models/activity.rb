class Activity < ActiveRecord::Base
  belongs_to :athlete
  belongs_to :leaderboard


  class << self

    def fetch_activities(page=1, per_page=30)
      @client      = Strava::Api::V3::Client.new(:access_token => ENV['STRAVA_TOKEN'])
      @club_id     = 202870

      club_activities = @client.list_club_activities(@club_id, per_page: per_page, page: page)
      new_activities  = create_activities(club_activities)

      unless new_activities.empty?
        Athlete.calc_new_totals_for_athletes(new_activities)
        Leaderboard.calc_new_leaderboards(new_activities)
      end
    end

    def create_activities(activities)
      new_activities = Array.new
      activities.each do |activity|
        begin
          if Activity.find(activity['id'])
            next
          end
        rescue
          athlete       = Athlete.get_or_create_athlete(activity['athlete'])
          full_activity = @client.retrieve_an_activity(activity['id'])
          calories      = calc_calories(full_activity)
          begin
            new_activity = create_activity(full_activity, athlete, calories)
          rescue
            new_activity = create_activity_without_loc(full_activity, athlete, calories)
          end
          new_activities.push(new_activity)
        end
      end
      new_activities
    end

    def calc_calories(activity)
      calories = 0
      if activity['calories'] and activity['calories'] != 0
        calories += activity['calories']
      elsif not activity['kilojoules'].nil?
        calories += kj_to_cal(activity['kilojoules'])
      else
        calories += time_to_cal(activity['moving_time'])
      end
      calories
    end

    def calc_beers(calories)
      calories_per_beer = 200
      calories / calories_per_beer
    end

    ####################################################
    private

      def create_activity(full_activity, athlete, calories)
        Activity.create(
            id:                   full_activity['id'], name: full_activity['name'], distance: full_activity['distance'],
            activity_type:        full_activity['type'], moving_time: full_activity['moving_time'],
            total_elevation_gain: full_activity['total_elevation_gain'],
            calories:             calories, start_lat: full_activity['start_latlng'][0],
            start_long:           full_activity['start_latlng'][1], end_lat: full_activity['end_latlng'][0],
            end_long:             full_activity['end_latlng'][1], kudos_count: full_activity['kudos_count'],
            created_at:           full_activity['start_date'], athlete_id: athlete.id,
            beers:                calc_beers(calories), timezone: full_activity['timezone'],
            start_date_local:     full_activity['start_date_local'])
      end

      def create_activity_without_loc(full_activity, athlete, calories)
        Activity.create(
            id:                   full_activity['id'], name: full_activity['name'], distance: full_activity['distance'],
            activity_type:        full_activity['type'], moving_time: full_activity['moving_time'],
            total_elevation_gain: full_activity['total_elevation_gain'],
            calories:             calories, kudos_count: full_activity['kudos_count'],
            created_at:           full_activity['start_date'], athlete_id: athlete.id,
            beers:                calc_beers(calories), timezone: full_activity['timezone'],
            start_date_local:     full_activity['start_date_local'])
      end

      def kj_to_cal(kj)
        1.1173 * kj
      end

      # Based on 400cal/hr
      def time_to_cal(sec)
        sec * 0.11111
      end

  end

end
