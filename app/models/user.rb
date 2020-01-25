class User < ActiveRecord::Base
  has_secure_password
  validates :password, presence: true
  validates :email, presence: true
  validates :username, presence: true


  has_many :tweets

  def slug
    self.username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(argSlug)
    self.all.find{|user| user.slug == argSlug}
  end
end
