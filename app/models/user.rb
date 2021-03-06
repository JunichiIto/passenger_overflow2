class User < ActiveRecord::Base
  attr_accessible :user_name

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :reputations

  validates :user_name, 
            presence: true, 
            length: { maximum: 20 },
            format: { with: /^[a-z0-9]+$/ },
            uniqueness: true

  def self.authenticate(user_name)
    find_by_user_name user_name
  end

  def vote(answer)
    votes.create answer: answer do |vote|
      if vote.save
        Reputation.create_for_vote! vote
      end
    end
  end

  def can_vote?(answer)
    !already_voted?(answer) && answer.user != self
  end
  
  def already_voted?(answer)
    votes.exists? answer_id: answer
  end

  def reputation_point
    reputations.sum(:point)
  end
end
