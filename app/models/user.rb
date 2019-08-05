class User < ActiveRecord::Base
  # has secure password
  has_secure_password
  has_many :tweets

  # validates :username, presence: true, uniqueness: true
  # validates :email, presence: true
  # validates :pasword, presence: true

  # slugs the username
  def slug
    self.username.gsub(" ", "-").downcase
  end

  # finds user based on slug
  def self.find_by_slug(slug)
    self.all.find{ |user| user.slug == slug }
  end
end
