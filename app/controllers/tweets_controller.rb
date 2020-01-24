class TweetsController < ApplicationController
    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'/tweets/index'
        else
            redirect '/login'
        end
    end

  get '/tweets/new' do
      if logged_in?
        erb :'tweets/new'
      else
        redirect '/login'
      end
  end

  post '/tweets' do 
      if !params[:content].empty? 
          clean_params = cleanse(params)
          @tweet = Tweet.create(content: clean_params[:content], user_id: "#{current_user.id}")
          redirect "/tweets/#{@tweet.id}"
      else
          redirect '/tweets/new'
      end
  end

  get '/tweets/:id' do
      if logged_in?
        clean_params = cleanse(params)
        @tweet = Tweet.find_by(id: clean_params[:id])
        erb :'/tweets/show'
      else 
        redirect '/login'
      end
  end

  get '/tweets/:id/edit' do
    clean_params = cleanse(params)
    @tweet = Tweet.find_by(id: clean_params[:id])
      if logged_in? && @tweet.user_id == current_user.id
        erb :'/tweets/edit'
      else
        redirect '/login'
      end
  end

  patch '/tweets/:id' do
    clean_params = cleanse(params)
    @tweet = Tweet.find(clean_params[:id])
      if logged_in? && !clean_params[:content].empty?
        @tweet.update(content: clean_params[:content])
        redirect "/tweets/#{@tweet.id}"
      else
        redirect "/tweets/#{@tweet.id}/edit}"
      end
  end

  delete '/tweets/:id' do
    clean_params = cleanse(params)
    @tweet = Tweet.find_by(id: clean_params[:id])
    if @tweet.user_id == current_user.id
        Tweet.delete(@tweet.id)
        redirect '/tweets'
    else
        redirect "/tweets/#{@tweet.id}"
    end
  end
end