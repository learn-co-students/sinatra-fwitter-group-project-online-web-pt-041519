class UsersController < ApplicationController
    
    get '/signup' do
        # binding.pry
        if logged_in?
            redirect '/tweets' 
        else
            erb :'/users/signup'
        end
    end

    post '/signup' do
        # binding.pry
        if params[:username] != "" && params[:email] != "" && params[:password] != ""
            # binding.pry
            nice_params = cleanse(params)
            @user = User.new(nice_params)
            if @user.save
                session[:user_id] = @user.id
                redirect '/tweets' 
            else
                erb :"/users/signup" 
            end
        else
            redirect  "/signup"
        end
    end  

    get '/login' do
        if logged_in?
            @failed = false
            redirect "/tweets"
        else 
            erb :"/users/login"
        end
    end

    post '/login' do
        nice_params = cleanse(params)
        @user = User.find_by(username: nice_params[:username])
        if @user && @user.authenticate(nice_params[:password])
            session[:user_id] = @user.id
            
            @failed = false
            redirect "/tweets"
        else
            @failed = true
            redirect "/login"
        end
    end

    get '/logout' do
        session.clear
        redirect "/login"
    end

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :"/users/show"
    end

    get '/users' do
        @users = User.all
        erb :'/users/index'
    end
end