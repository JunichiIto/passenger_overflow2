class Answer < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :question
  has_many :votes
  
  validates :content, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  default_scope order: "answers.created_at DESC"

  def accepted
    if question.accepted_answer
      errors[:base] << "Already accepted"
      return nil
    end

    question.accepted_answer = self
    self.class.transaction do
      question.save!
      if user != question.user
        question.user.reputations.create! reason: "accepted", point: 2, activity: self
        user.reputations.create! reason: "accept", point: 15, activity: self
      end
    end
  end
end
