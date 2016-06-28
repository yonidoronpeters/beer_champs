class Leaderboard < ActiveRecord::Base

  # TODO return an entity of leaderboard and persist it to db. Then can easily aggregate totals for 2 days, 1 week, 1 month, etc.
  # or persist at 23:59 every night instead
  def Leaderboard.calc_todays_stats
    athlete_to_activities = Hash.new
    athletes              = Athlete.all
    athletes.each do |athlete|
      athlete_to_activities[athlete] = athlete.activities.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
    end
    self.reduce_stats(athlete_to_activities)
  end

  def Leaderboard.reduce_stats(hsh)
    athlete_totals = []
    hsh.each do |athlete, activities|
      beers    = 0
      calories = 0

      activities.each do |act|
        beers    += act.beers
        calories += act.calories
      end if activities
      athlete_totals << { name: athlete.name, img_url: athlete.img_url, beers: beers, calories: calories, id: athlete.id }
    end
    athlete_totals
        .sort_by { |h| h[:beers] }
        .reject { |h| h[:calories] == 0 }
        .reverse
  end

end
