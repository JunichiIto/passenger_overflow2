class User < ActiveRecord::Base
  attr_accessible :user_name

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :reputations

  user_name_regex = /^[a-z0-9]+$/
  validates :user_name, 
            :presence => true, 
            :length => { :maximum => 20 },
            :format => { :with => user_name_regex },
            :uniqueness => true

  def self.authenticate(user_name)
    find_by_user_name user_name
  end

  def vote!(answer)
    vote = votes.build user: self, answer: answer
    vote.save!
  end
  
  def already_voted?(answer)
    votes.exists? answer_id: answer
  end
end
