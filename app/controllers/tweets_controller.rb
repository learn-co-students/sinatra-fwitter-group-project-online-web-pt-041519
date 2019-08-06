class TweetsController < ApplicationController

  # Tweets index
  get '/tweets' do
    # If logged in, show tweets
    if logged_in?
      @tweets = Tweet.all
      erb :'tweets/tweets'
    # Else redirect to login
    else
      redirect '/login'
    end
  end

  # Display tweet creation form
  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    # Else redirect to login
    else
      redirect '/login'
    end    
  end

  # Create and save new tweet in database
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

  # Show tweet
  get '/tweets/:id' do 
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect '/login'
    end 
  end

  # Show edit form
  get '/tweets/:id/edit' do 
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/edit_tweet'
    else
      redirect '/login'
    end          
  end

  # Delete tweet
  delete '/tweets/:id/delete' do
    # binding.pry
    if logged_in? 
      tweet = Tweet.find(params[:id])      
      # binding.pry
      # && !!current_user
      tweet.destroy if current_user == tweet.user
      redirect '/tweets'
    else
      redirect '/login'
    end    
  end

  # Update tweet
  patch '/tweets/:id' do  
    if logged_in?   
      if params[:content].empty?
        redirect "/tweets/#{params[:id]}/edit"
      else 
        # Find tweet and update
        tweet = Tweet.find(params[:id])
        if current_user == tweet.user
          tweet.update(content: params[:content])
          redirect "/tweets/#{tweet.id}"
        else 
          redirect '/login'
        end
      end
    else
      redirect '/login'
    end    
  end
  
end
