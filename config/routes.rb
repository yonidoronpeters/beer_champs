Rails.application.routes.draw do
  root to: redirect('/leaderboard')
  get '/leaderboard', to: 'leaderboard#index'
end
