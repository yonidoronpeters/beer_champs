desc "This task is called by the Heroku scheduler add-on to persist the leaderboard at the end of each day"
task :save_leaderboard => :environment do
  puts "Saving leaderboard..."
  Leaderboard.persist_todays_leaderboard
  puts "Done."
end

task :fetch_activities => :environment do
  puts "Fetching new activities..."
  Activity.fetch_activities
  puts "Done."
end