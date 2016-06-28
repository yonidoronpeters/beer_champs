class Activity < ActiveRecord::Base
  belongs_to :athlete

  def Activity.calc_calories(activity)
    calories = 0
    if activity['calories'] and activity['calories'] != 0
      calories += activity['calories']
    elsif not activity['kilojoules'].nil?
      calories += self.kj_to_cal(activity['kilojoules'])
    else
      calories += self.time_to_cal(activity['moving_time'])
    end
    calories
  end

  def Activity.calc_beers(calories)
    calories_per_beer = 200
    calories / calories_per_beer
  end

  private

    def Activity.kj_to_cal(kj)
      1.1173 * kj
    end

    def Activity.time_to_cal(sec)
      sec * 0.08333
    end

end
