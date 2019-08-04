class CreateUsers < ActiveRecord::Migration
  def change
    #user table
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest  
    end
  end
end
