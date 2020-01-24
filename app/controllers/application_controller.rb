require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, SESSION_SECRET
  end

  get '/' do
    erb :index
  end


    helpers do
          
      def logged_in?
        !!session[:user_id]
      end

      def current_user
        User.find(session[:user_id])
      end

      def cleanse(params)
          nice_params = params.dup
          params.each do |k,v| 
              nice_params[k] = Rack::Utils.escape_html(v)
          end 
          nice_params
      end

    end

end
