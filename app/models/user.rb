class User < ActiveRecord::Base
  attr_accessible :user_name

  user_name_regex = /^[a-z0-9]+$/
  validates :user_name, 
            :presence => true, 
            :length => { :maximum => 20 },
            :format => { :with => user_name_regex },
            :uniqueness => true
end
