class UsersController < ApplicationController

  # Display signup page
  get '/signup' do
    if logged_in?
      redirect "/tweets"
    else 
      erb :'users/create_user'
    end
  end

  # Create user
  post '/signup' do
    if params[:username].empty? || params[:password].empty? || params[:email].empty? 
      redirect "/signup"
    else 
      user = User.new(params)
    end

    if user.save
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

  # Display user show page
  get '/users/:slug' do
    # binding.pry
    @user = User.find_by_slug(params[:slug])
    # if logged_in?
      erb :'users/show'
    # else 
    #   redirect '/login'
    # end
  end

  # Display login page
  get '/login' do
    if logged_in?
      redirect '/tweets'
    else 
      erb :'users/login'
    end
  end

  # Get user from database
  post '/login' do
		user = User.find_by(username: params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect '/tweets'
		else
			redirect '/login'
		end
  end

  # Log out
  get '/logout' do
    if logged_in?
      session.clear
     redirect '/login'
    else 
      redirect '/'
    end
  end

end
