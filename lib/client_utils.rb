module ClientUtils
  def client
    @client ||= Strava::Api::V3::Client.new(:access_token => ENV['STRAVA_TOKEN'])
  end
end