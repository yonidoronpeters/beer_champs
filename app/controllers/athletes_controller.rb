class AthletesController < ApplicationController
  before_action :set_athlete, only: [:show, :edit, :update, :destroy]

  # GET /athletes
  # GET /athletes.json
  def index
    @athletes = Athlete.all
  end

  # GET /athletes/1
  # GET /athletes/1.json
  def show
  end

  # GET /athletes/new
  def new
    @athlete = Athlete.new
  end

  # GET /athletes/1/edit
  def edit
  end

  # POST /athletes
  # POST /athletes.json
  def create
    @athlete = Athlete.new(athlete_params)

    respond_to do |format|
      if @athlete.save
        format.html { redirect_to @athlete, notice: 'Athlete was successfully created.' }
        format.json { render :show, status: :created, location: @athlete }
      else
        format.html { render :new }
        format.json { render json: @athlete.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /athletes/1
  # PATCH/PUT /athletes/1.json
  def update
    respond_to do |format|
      if @athlete.update(athlete_params)
        format.html { redirect_to @athlete, notice: 'Athlete was successfully updated.' }
        format.json { render :show, status: :ok, location: @athlete }
      else
        format.html { render :edit }
        format.json { render json: @athlete.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /athletes/1
  # DELETE /athletes/1.json
  def destroy
    @athlete.destroy
    respond_to do |format|
      format.html { redirect_to athletes_url, notice: 'Athlete was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def leaderboard
    @client = Strava::Api::V3::Client.new(:access_token => ENV['STRAVA_TOKEN'])
    club_id = 202870

    club_activities = @client.list_club_activities(club_id)
    athletes_hash = filter_by_date(club_activities)

    @athletes = calculate_beers_for_athlete(athletes_hash).keys.sort_by { |athlete| athlete.beers}.reverse
    render 'no_beers' if @athletes.empty?
  end

  #####################################################

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_athlete
      @athlete = Athlete.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def athlete_params
      params.require(:athlete).permit(:name, :calories, :beers, :activity, :img_url)
    end

    def calculate_beers_for_athlete(athletes_hash)
      athletes_hash.each do |athlete, ids|
        athlete.calories = get_calories_for_athlete(ids)
        athlete.beers = calc_beers(athlete.calories)
      end
      athletes_hash
    end

    def calc_beers(calories)
      calories_per_beer = 200
      beers = calories / calories_per_beer
    end

    def filter_by_date(activities)
      athletes = Hash.new([])
      activities.each do |activity|
        if Date.parse(activity['start_date_local']).today? # fix bug with timezone
          athlete = get_or_create_athlete(activity)
          if athletes[athlete].empty?
            athletes[athlete] = [activity['id']]
          else
            athletes[athlete].push(activity['id'])
          end
        end
      end
      athletes
    end

    def get_or_create_athlete(activity)
      id       = activity['athlete']['id']
      athlete = Athlete.find(id)
      if athlete.nil?
        username = activity['athlete']['username']
        name     = activity['athlete']['firstname'] + " " + activity['athlete']['lastname']
        img_url  = activity['athlete']['profile']
        athlete = Athlete.create(name: name, img_url: img_url, id: id, username: username)
      end
      athlete
    end

    def get_calories_for_athlete(activity_ids)
      calories = 0
      activity_ids.each do |id|
        activity = @client.retrieve_an_activity(id)
        if not activity['calories'].nil?
          calories += activity['calories']
        elsif not activity['kilojoules'].nil?
          calories += kj_to_cal(activity['kilojoules'])
        else
          calories += time_to_cal(activity['moving_time'])
        end
      end
      calories
    end

    def kj_to_cal(kj)
       1.1173 * kj
    end

    def time_to_cal(sec)
      sec * 0.08333
    end
end
