class CreateTweets < ActiveRecord::Migration
  def change
    #tweets table
    create_table :tweets do |t|
      t.string :content
      t.string :user_id
    end
  end
end
