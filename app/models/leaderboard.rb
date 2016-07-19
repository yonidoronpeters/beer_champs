class Leaderboard < ActiveRecord::Base
  has_many :activities
  before_destroy :detach_dependent_activities


  class << self

    def calc_new_leaderboards(new_activities)
      todays_leaderboards = Leaderboard.where(created_at: Time.now.utc.beginning_of_day..Time.now.utc.end_of_day)
      new_activities.each do |activity|
        update_todays_leaderboards(activity, todays_leaderboards)
      end
    end

    def get_leaderboard_for_day(date=Time.zone.now.beginning_of_day.utc)
      Leaderboard
          .where(created_at: date.midnight..date.end_of_day)
          .sort_by { |l| l.calories }
          .reverse
    end

    ################################################
    private
      def update_todays_leaderboards(activity, todays_leaderboards)
        l = todays_leaderboards.where(athlete_id: activity.athlete_id).take
        if l.nil?
          l = create_new_entry(activity)
        else
          l = update_entry(activity, l)
        end
        l.activities << activity
        l.save
      end

      def update_entry(activity, l)
        l.calories += activity.calories
        l.beers    = Activity.calc_beers(l.calories)
      end

      def create_new_entry(activity)
        athlete = Athlete.find(activity.athlete_id)
        Leaderboard.new(athlete_name: athlete.name, athlete_id: athlete.id, img_url: athlete.img_url,
                                  beers: activity.beers, calories: activity.calories, activity_id: activity.id,
                                  created_at: activity.start_date_local)
      end
  end

  #################################################
  private
    def detach_dependent_activities
      if activities
        activities.each do |a|
          a.leaderboard_id = nil
          a.save
        end
      end
    end
end
