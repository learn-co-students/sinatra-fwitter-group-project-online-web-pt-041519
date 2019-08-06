require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, "secret"

  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect to("/tweets")
    end

    erb :signup
  end

  post '/signup' do
    user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
    if user.save && !user.username.empty? && !user.email.empty?
      session[:user_id] = user.id
      user.save
      redirect to("/tweets")
    else
      redirect to("/signup")
    end

  end

  get '/tweets' do
    if !logged_in?
      redirect to("/login")
    end
    @tweets = Tweet.all
    erb :'/tweets/tweets'
  end


  get '/login' do
    if logged_in?
      redirect to("/tweets")
    end
    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && !user.username.empty? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to("/tweets")
    else
      redirect to('/login')
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect "/login"
    else
      redirect to '/'
    end
  end

  get '/tweets/new' do
    if !logged_in?
      redirect "/login"
    end
    erb :'tweets/new'
  end

  post '/tweets' do
    if params[:content].empty?
      redirect to '/tweets/new'
    else
      tweet = Tweet.create(content: params[:content])
    end
    current_user.tweets << tweet
    current_user.save
    @slug = current_user.slug
    redirect to "/users/#{@slug}"
  end

  get '/users/:slug' do
    @current_user_tweets = current_user.tweets
    erb :'users/show'
  end

  get '/tweets/:tweet_id' do
    if !logged_in?
      redirect "/login"
    end
    @tweet = Tweet.find_by(id: params[:tweet_id])
    erb :'tweets/show_tweet'
  end

  get '/tweets/:tweet_id/edit' do
    if !logged_in?
      redirect "/login"
    end
    @tweet = Tweet.find_by(id: params[:tweet_id])
    erb :'tweets/edit_tweet'
  end

  patch '/tweets/:tweet_id/edit' do
    @tweet = Tweet.find_by(id: params[:tweet_id])
    @tweet.content = params[:content]
    @tweet.save
    erb :'tweets/show_tweet'
  end

  delete '/tweets/:tweet_id' do
    @delete_tweet = Tweet.find_by(id: params[:tweet_id])
    if logged_in? && current_user.tweets.include?(@delete_tweet)
      @delete_tweet.destroy
    else
      redirect "/login"
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
