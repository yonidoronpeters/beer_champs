class Leaderboard < ActiveRecord::Base
  has_many :activities

  # TODO return an entity of leaderboard and persist it to db. Then can easily aggregate totals for 2 days, 1 week, 1 month, etc.
  # or persist at 23:59 every night instead
  def Leaderboard.calc_todays_stats
    todays_activities = Activity.where("created_at >= ?", Time.zone.now.yesterday.utc) #created_at: Date.today.beginning_of_day..Date.today.end_of_day)
    self.reduce_stats(todays_activities)
  end

  def Leaderboard.reduce_stats(activities)
    athlete_totals = Hash.new
    activities.each do |activity|
      if athlete_totals[activity.athlete_id]
        athlete_totals[activity.athlete_id][:calories] += activity.calories
        athlete_totals[activity.athlete_id][:beers] += Activity.calc_beers(athlete_totals[activity.athlete_id][:calories])
      else
        athlete = Athlete.find(activity.athlete_id)
        athlete_totals[athlete.id] = { name: athlete.name, id: athlete.id, img_url: athlete.img_url,
                                      beers: activity.beers, calories: activity.calories }
      end
    end
    athlete_totals
        .values
        .sort_by { |h| h[:calories] }
        .reject  { |h| h[:calories] == 0 }
        .reverse
  end

end
