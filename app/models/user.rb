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

  def vote!(answer)
    vote = votes.build user: self, answer: answer
    ActiveRecord::Base.transaction do
      vote.save!
      answer.user.reputations.create! activity: vote, reason: "upvote", point: 10
    end
    vote
  end
  
  def already_voted?(answer)
    votes.exists? answer_id: answer
  end

  def reputation_point
    Reputation.where("user_id = ?", id).sum(:point)
  end
end
