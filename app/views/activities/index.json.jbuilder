json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :distance, :type, :moving_time, :total_elevation_gain, :calories, :start_lat, :start_long, :end_lat, :end_long, :kudos_count
  json.url activity_url(activity, format: :json)
end
