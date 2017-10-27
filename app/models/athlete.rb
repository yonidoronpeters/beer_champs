require 'client_utils'

class Athlete < ApplicationRecord
  extend ClientUtils
  has_many :activities

  def Athlete.calc_new_totals_for_athletes(new_activities)
    new_activities.each do |activity|
      athlete = Athlete.find(activity.athlete_id)
      athlete.calories += activity.calories
      athlete.beers = Activity.calc_beers(athlete.calories)
      athlete.save
    end
  end

  def Athlete.get_or_create_athlete(activity_athlete)
    id = activity_athlete['id']
    begin
      athlete = Athlete.find(id)
    rescue
      username = activity_athlete['username']
      name     = activity_athlete['firstname'] + " " + activity_athlete['lastname']
      img_url  = activity_athlete['profile']
      athlete  = Athlete.create(name: name, img_url: img_url, id: id, username: username, calories: 0.0, beers: 0.0)
    end
    athlete
  end

  def Athlete.sync_athletes(athletes=nil)
    athletes ||= Athlete.all
    athletes.each do |athlete|
      begin
        updated = client.retrieve_another_athlete(athlete.id)
        athlete.update(name: updated['firstname'] + " " + updated['lastname'],
                       username: updated['username'],
                       img_url: updated['profile'])
      rescue Strava::Api::V3::ClientError
        # athlete profile deleted on strava
        athlete.destroy
      end
    end
  end

end
