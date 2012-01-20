class User < ActiveRecord::Base
  attr_accessible :user_name
  validates :user_name, :presence => true
end
