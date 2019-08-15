class TweetsController < ApplicationController
  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end

  # new tweet form 
  get '/tweets/new' do
    if logged_in?
      erb :"tweets/create_tweet"
    else
      redirect to "/login"
    end
  end

  # create + save tweet
  post '/tweets' do
    if params[:content].empty?
      redirect '/tweets/new'
    else 
      tweet = current_user.tweets.build(content: params[:content])
      if tweet.save
        redirect to "/tweets/#{tweet.id}"
      else
        redirect to "/tweets/new"
      end      
    end
  end

  # show a tweet 
  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to "/login"
    end
  end

  # show edit form is user is logged in 
  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      if @tweet.user == current_user
        erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

  # edit tweet if user is logged in 
  patch '/tweets/:id' do  
    if logged_in?   
      if params[:content].empty?
        redirect "/tweets/#{params[:id]}/edit"
      else 
        # Find tweet and update
        @tweet = Tweet.find(params[:id])
        if @tweet.user == current_user
          @tweet.update(content: params[:content])
          redirect "/tweets/#{@tweet.id}"
        else 
          redirect '/login'
        end
      end
    else
      redirect '/login'
    end    
  end


  delete '/tweets/:id/delete' do
    if logged_in? 
      @tweet = Tweet.find(params[:id])      
      if @tweet.user == current_user
        @tweet.destroy
      end
      redirect '/tweets'
    else
      redirect '/login'
    end    
  end
end