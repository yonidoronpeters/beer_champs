class Leaderboard < ApplicationRecord
  has_many :activities, dependent: :nullify

  class << self
    def calc_new_leaderboards(new_activities)
      new_activities.each { |activity| update_leaderboard_with activity }
    end

    def get_leaderboard_for_day(date = Date.current)
      Leaderboard.where(activity_date_local: date).order(calories: :desc)
    end

    ################################################
    private
      def update_leaderboard_with(activity)
        l = Leaderboard.where(athlete_id: activity.athlete_id,
                              activity_date_local: activity.start_date_only).first
        return if l && l.activities.include?(activity)
        l = l ? update_entry(activity, l) : create_new_entry(activity)
        l.activities << activity
      end

      def update_entry(activity, l)
        new_calories = l.calories + activity.calories
        l.update_attributes(
          calories: new_calories,
          beers: Activity.calc_beers(new_calories)
        )
        l.reload
      end

      def create_new_entry(activity)
        athlete = Athlete.find(activity.athlete_id)
        Leaderboard.create!(
          athlete_name: athlete.name, athlete_id: athlete.id,
          img_url: athlete.img_url, beers: activity.beers,
          calories: activity.calories,
          activity_date_local: activity.start_date_only
        )
      end
  end
end
