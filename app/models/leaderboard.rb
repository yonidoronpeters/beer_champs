class Leaderboard < ActiveRecord::Base
  has_many :activities


  class << self
    # TODO return an entity of leaderboard and persist it to db. Then can easily aggregate totals for 2 days, 1 week, 1 month, etc.
    # or persist at 23:59 every night instead
    def calc_todays_stats
      todays_activities = Activity.where("created_at >= ?", Time.zone.now.yesterday.utc) #created_at: Date.today.beginning_of_day..Date.today.end_of_day)
      create_leaderboard(todays_activities)
    end

    ################################################
    private
      def create_leaderboard(activities)
        leaderboard = Hash.new
        activities.each do |activity|
          if leaderboard[activity.athlete_id]
            total_existing_entry(activity, leaderboard)
          else
            create_leaderboard_entry(activity, leaderboard)
          end
        end
        leaderboard
            .values
            .sort_by { |l| l.calories}
            .reject  { |l| l.calories == 0 }
            .reverse
      end

      def total_existing_entry(activity, leaderboard)
        leaderboard[activity.athlete_id].calories += activity.calories
        leaderboard[activity.athlete_id].beers    += Activity.calc_beers(leaderboard[activity.athlete_id].calories)
      end

      def create_leaderboard_entry(activity, leaderboard)
        athlete                 = Athlete.find(activity.athlete_id)
        leaderboard_entry       = Leaderboard.new(athlete_name: athlete.name, athlete_id: athlete.id, img_url: athlete.img_url,
                                                  beers: activity.beers, calories: activity.calories, activity_id: activity.id)
        leaderboard[athlete.id] = leaderboard_entry
      end
  end
end
