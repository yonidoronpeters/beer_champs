json.array!(@athletes) do |athlete|
  json.extract! athlete, :id, :name, :calories, :beers, :activity, :img_url
  json.url athlete_url(athlete, format: :json)
end
