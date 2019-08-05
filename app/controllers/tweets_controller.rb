class TweetsController < ApplicationController

  # tweets index
  get '/tweets' do
    # does not load /tweets index if user is not logged in
    # does load /tweets index if user is logged in
    if logged_in?
      # set instance variable as current_user via helper method
      @user = current_user
      # makes all tweets available via instance variable
      @tweets = Tweet.all

      # loads tweet index
      erb :'tweets/tweets'
    else
      redirect to "/login"
    end
  end

  # create
  get '/tweets/new' do
    # user can view new tweet form if logged in
    # user can create tweet if logged in
    # user cannot view new tweet form if not logged in
    if logged_in?
      erb :'/tweets/new'
    else
      redirect '/login'
    end
  end

  # create
  post '/tweets' do
    # does not let user create a blank tweet
    if !params[:content].empty?
      # tweet is saved as logged in user
      tweet = Tweet.create(content: params[:content], user: current_user)
      tweet.save
            
      redirect '/tweets'
    else
      redirect to '/tweets/new'
    end
  end

  # read
  get '/tweets/:id' do
    # logged in user can view a single tweet
    # logged out user cannot view a single tweet
    if logged_in?
      # sets tweet id to instance variable to that tweet's data can be viewed
      @tweet = Tweet.find_by_id(params[:id])

      erb :'tweets/show_tweet'
    else
      # if not logged in redirects user to login page
      redirect to '/login'
    end
  end

  # update
  get '/tweets/:id/edit' do
    # sets tweet id to instance variable to that tweet's data can be viewed/edited
    @tweet = Tweet.find_by(params[:id])

    # lets a user use tweet edit form if logged in
    # does not let a user edit a tweet they did not create
    # if user is logged in can edit their own tweet
    if logged_in? && @tweet.user_id == current_user.id
      erb :'/tweets/edit_tweet'
    else
      # does not load edit form if user not logged in, redirects to login page
      redirect '/login'
    end
  end

  # update
  patch '/tweets/:id' do
    # sets tweet id to instance variable to that tweet's data can be viewed/edited
    tweet = Tweet.find_by(id: params[:id])
    
    # does not let user edit text with blank content
    if !params[:content].empty? 
      # update/saves edited tweet and sends back to that tweet's page
      tweet.update(content: params[:content])
      redirect to "/tweets/#{tweet.id}"
    else
      # if content is empty redirects to edit form
      redirect to "/tweets/#{tweet.id}/edit"
    end
  end

  # delete
  delete '/tweets/:id' do
    # sets tweet id to instance variable to that tweet's data can be viewed/edited
    tweet = Tweet.find_by_id(params[:id])
    
    # allows user to delete tweet if logged in
    # does lot let user delete tweet they did not create
    if tweet.user_id == current_user.id
      tweet.delete
    end
      # send user to tweet index after deletion
      # does not load/let user delete tweet if not logged in
      redirect '/tweets'
  end

end
