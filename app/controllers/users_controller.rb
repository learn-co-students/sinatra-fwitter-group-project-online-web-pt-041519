class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    post '/login' do
        @user = User.find_by(username: params[:username], password: params[:password])
        if @user
            session[:user_id] = @user.id
            redirect '/tweets'
        end 
    end

    get '/signup' do
        erb :'users/signup'
    end




end
