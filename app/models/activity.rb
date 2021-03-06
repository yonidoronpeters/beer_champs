require 'client_utils'

class Activity < ApplicationRecord
  extend ClientUtils
  belongs_to :athlete
  belongs_to :leaderboard
  before_destroy :delete_leaderboard_if_empty

  class << self
    def fetch_activities(page=1, per_page=30)
      club_activities = client.list_club_activities(
        ENV['CLUB_ID'], per_page: per_page, page: page
      )
      new_activities  = create_activities(club_activities)

      unless new_activities.empty?
        Athlete.calc_new_totals_for_athletes(new_activities)
        Leaderboard.calc_new_leaderboards(new_activities)
      end
    end

    def create_activities(activities)
      new_activities = []
      activities.each do |activity|
        if Activity.exists?(activity['id'])
          update_activity(activity)
        else
          new_activity = new_activity(activity)
          new_activities.push(new_activity)
        end
      end
      new_activities
    end

    def calc_calories(activity)
      calories = 0
      if activity['calories'] && activity['calories'] != 0
        calories += activity['calories']
      elsif !activity['kilojoules'].blank?
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

      def new_activity(activity)
        athlete  = Athlete.get_or_create_athlete(activity['athlete'])
        calories = calc_calories(activity)
        begin
          new_activity = create_activity(activity, athlete, calories)
        rescue
          new_activity = create_activity_without_loc(activity, athlete, calories)
        end
        new_activity
      end

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
          start_date_local:     full_activity['start_date_local']
        )
      end

      def create_activity_without_loc(full_activity, athlete, calories)
        Activity.create(
          id:                   full_activity['id'], name: full_activity['name'], distance: full_activity['distance'],
          activity_type:        full_activity['type'], moving_time: full_activity['moving_time'],
          total_elevation_gain: full_activity['total_elevation_gain'],
          calories:             calories, kudos_count: full_activity['kudos_count'],
          created_at:           full_activity['start_date'], athlete_id: athlete.id,
          beers:                calc_beers(calories), timezone: full_activity['timezone'],
          start_date_local:     full_activity['start_date_local']
        )
      end

      def update_activity(latest)
        updated = Activity.update(latest['id'],
                          name: latest['name'],
                          activity_type: latest['type'],
                          kudos_count: latest['kudos_count'])
        reload_leaderboard(updated)
      end

      def reload_leaderboard(activity)
        begin
          Leaderboard.find(activity.leaderboard_id).activities.reload
        rescue ActiveRecord::RecordNotFound
          # activity is not part of leaderboard yet. No need to reload
        end
      end

      def kj_to_cal(kj)
        1.1173 * kj
      end

      # Based on 600cal/hr
      def time_to_cal(sec)
        # 600cal/60min/60sec = 0.16667
        sec * 0.16667
      end
  end

  private
    def delete_leaderboard_if_empty
      leaderboard.destroy if !leaderboard.nil? && leaderboard.activities.length == 1
    end
end
