class Leaderboard < ApplicationRecord
  has_many :activities, dependent: :nullify

  class << self
    def calc_new_leaderboards(new_activities)
      new_activities.each { |activity| update_leaderboard_with activity }
    end

    def get_leaderboard_for_day(date=Time.zone.now.beginning_of_day.utc)
      Leaderboard
          .where(created_at: date.midnight..date.end_of_day)
          .order(calories: :desc)
    end

    ################################################
    private
      def update_leaderboard_with(activity)
        l = Leaderboard.where(athlete_id: activity.athlete_id,
                              created_at: activity.start_date_local.beginning_of_day..activity.start_date_local.end_of_day).take
        return if l && l.activities.include?(activity)
        l = l ? update_entry(activity, l) : create_new_entry(activity)
        l.activities << activity
      end

      def update_entry(activity, l)
        new_calories = l.activities.sum(:calories) + activity.calories
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
          calories: activity.calories, created_at: activity.start_date_local
        )
      end
  end
end
