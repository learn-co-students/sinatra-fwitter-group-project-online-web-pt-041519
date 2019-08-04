class UsersController < ApplicationController
   get '/' do
      erb :index
    end
  
    get '/signup' do
      erb :"/users/create_user"
    end
  
    # submit the form's info + create an object
    post "/signup" do
      #your code here
      user = User.create(username: params[:username], password: params[:password])
      if user.save && user.username != "" && user.email != "" && user.password != ""
        redirect to 'controllers/tweets_controller/tweets'
      else 
        redirect to '/signup'
      end
    end

    helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end
