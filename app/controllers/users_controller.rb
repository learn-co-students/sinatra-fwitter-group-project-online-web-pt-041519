class UsersController < ApplicationController
  get '/login' do
      if logged_in?
          redirect '/tweets'
      else
          erb :"/users/login"
      end
  end

  post '/login' do
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect '/tweets'
      else
          redirect '/login'
      end
  end

  get '/signup' do
      if !logged_in?
          erb :"/users/signup"
      else
          redirect '/tweets'
      end
  end

  post '/signup' do
      if params[:username] == "" || params[:password] == "" || params[:email] == ""
          redirect '/signup'
      else
          user = User.create(email: params[:email], username: params[:username], password: params[:password])
          session[:user_id] = user.id
          redirect '/tweets'
      end
  end

  get '/logout' do
      session.clear if logged_in?
      redirect '/login'
  end

  post '/logout' do
      session.clear
      redirect '/login'
  end

  get '/users/:id' do
      @tweets = Tweet.where(user_id: params[:id])
      @user = User.find(params[:id]).username
      erb :'users/index'
  end
end