class AthletesController < ApplicationController
  # GET /athletes
  # GET /athletes.json
  def index
    @athletes = Athlete.all
  end

  # GET /athletes/1
  # GET /athletes/1.json
  def show
    @athlete = Athlete.find(params[:id])
  end
end
