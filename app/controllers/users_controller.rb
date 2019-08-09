class UsersController < ApplicationController

    get '/login' do
      if logged_in?
        redirect to '/tweets'
      else
        erb :'users/login'
      end
    end

    post '/login' do
      user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/tweets'
      else
        redirect to '/signup'
      end 
    end

    get '/signup' do
      if logged_in?
        redirect to '/tweets'
      else
        erb :'users/signup'
      end
    end

    post '/signup' do
      if params[:username] == "" || params[:email] == "" || params[:password] == ""
        redirect to '/signup'
      else
        @user = User.new(username: params[:username], password: params[:password], email: params[:email])
        @user.save
        session[:user_id] = @user.id
        redirect '/tweets'
      end
    end

    get '/logout' do
        if logged_in?
          session.clear
          redirect to '/login'
        else
          redirect to '/login'
        end
    end




end
