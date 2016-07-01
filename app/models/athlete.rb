class Athlete < ActiveRecord::Base
  has_many :activities

  def Athlete.calc_new_totals_for_athletes(new_activities)
    new_activities.each do |activity|
      athlete = Athlete.find(activity.athlete_id)
      athlete.calories += activity.calories
      athlete.beers = Activity.calc_beers(athlete.calories)
      athlete.save
    end
  end

end
