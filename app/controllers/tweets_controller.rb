class TweetsController < ApplicationController

  get '/tweets' do
      if logged_in?
          @tweets = Tweet.all
        erb :'tweets/index'
      else
        redirect to '/login'
      end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:content]==""
      redirect to '/tweets/new'
    else
      @tweet = Tweet.new(content: params[:content])
      @tweet.save
      current_user.tweets << @tweet
      redirect "/tweets/#{@tweet.id}"
    end
  end

  get '/tweets/:id' do
    @tweets = Tweet.all
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      erb :'tweets/show'
    else
      redirect '/login'
    end
  end

  post '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      if params[:content] == ""
        redirect to "/tweets/#{params[:id]}/edit"
      else
        @tweet.content = params[:content]
        @tweet.save
        redirect "/tweets/#{@tweet.id}"
      end
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      if @tweet.user == current_user
        erb :'tweets/edit'
      end
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && @tweet.user == current_user
      @tweet.delete
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  


end