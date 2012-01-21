class User < ActiveRecord::Base
  attr_accessible :user_name

  has_many :questions

  user_name_regex = /^[a-z0-9]+$/
  validates :user_name, 
            :presence => true, 
            :length => { :maximum => 20 },
            :format => { :with => user_name_regex },
            :uniqueness => true

  def self.authenticate(user_name)
    find_by_user_name user_name
  end
end
