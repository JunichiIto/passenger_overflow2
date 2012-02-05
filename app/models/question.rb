class Question < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :answers
  belongs_to :accepted_answer, class_name: "Answer"

  validates :title, :presence => true, :length => { :maximum => 255 }
  validates :content, :presence => true
  validates :user_id, :presence => true

  default_scope :order => 'questions.created_at DESC'

  def accept!(answer)
    #TODO should use transaction??
    self.accepted_answer = answer
    save!
    if answer.user != user
      user.reputations.create! reason: "accepted", point: 2, activity: answer
      answer.user.reputations.create! reason: "accept", point: 15, activity: answer
    end
  end

  def accepted?
    accepted_answer
  end
end
