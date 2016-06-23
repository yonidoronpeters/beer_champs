class Leaderboard < ActiveRecord::Base

  def Leaderboard.calculate_beers_for_athletes(athletes_hash)
    athletes_hash.each do |athlete, activities|
      athlete.calories = self.get_calories_for_athlete(activities)
      athlete.beers = self.calc_beers(athlete.calories)
    end
    athletes_hash
  end

  def Leaderboard.get_calories_for_athlete(activities)
    calories = 0
    activities.each do |activity|
      if activity['calories'] and activity['calories'] != 0
        calories += activity['calories']
      elsif not activity['kilojoules'].nil?
        calories += self.kj_to_cal(activity['kilojoules'])
      else
        calories += self.time_to_cal(activity['moving_time'])
      end
    end
    calories
  end

  private

    def Leaderboard.calc_beers(calories)
      calories_per_beer = 200
      calories / calories_per_beer
    end

    def Leaderboard.kj_to_cal(kj)
      1.1173 * kj
    end

    def Leaderboard.time_to_cal(sec)
      sec * 0.08333
    end

end
