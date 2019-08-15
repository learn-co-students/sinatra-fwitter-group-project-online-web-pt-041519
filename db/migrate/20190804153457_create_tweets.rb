class CreateTweets < ActiveRecord::Migration
  def change
    #tweets table
    create_table :tweets do |t|
      t.text :content
      t.integer :user_id
    end
  end
end
