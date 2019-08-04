require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, "password_security"
  end

  get '/tweets' do
    'fucker'
  end


  #helper methods
  #is_logged_in
  #current_user

  


end
