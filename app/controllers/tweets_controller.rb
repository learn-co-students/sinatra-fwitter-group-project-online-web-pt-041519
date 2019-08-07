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
            erb :'/tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        if params[:content] == ""
            redirect 'tweets/new'
        else
            tweet = Tweet.create(content: params[:content], user_id: current_user.id)
            redirect '/tweets'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find(params[:id])
            erb :'/tweets/show'
        else
            redirect '/login'
        end
    end

    delete '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if @tweet.user == current_user
            Tweet.delete(params[:id])
            redirect '/tweets'
        else
            redirect "/tweets/#{params[:id]}"
        end
    end

    get "/tweets/:id/edit" do
        if logged_in?
            @tweet = Tweet.find(params[:id])
            erb :'/tweets/edit'
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do
        if params[:content] == ""
            redirect "/tweets/#{params[:id]}/edit"
        else
            @tweet = Tweet.find(params[:id])
            @tweet.update(content: params[:content])
            redirect "/tweets/#{params[:id]}"
        end
    end

end
