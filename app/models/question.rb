class Question < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :answers
  belongs_to :accepted_answer, class_name: "Answer"

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :user_id, presence: true
  validate_on_update :first_acception?

  default_scope order: "questions.created_at DESC"

  def accept(answer)
    @on_accept = true
    self.accepted_answer = answer
    self.class.transaction do
      return false unless save
      if user != answer.user
        user.reputations.create! reason: "accepted", point: 2, activity: answer
        answer.user.reputations.create! reason: "accept", point: 15, activity: answer
      end
    end
    true
  end

  def accepted?
    accepted_answer
  end

  private
  def first_acception?
    if @on_accept && !self.class.find(self).accepted_answer.nil?
      errors.add :base, "Already accepted"
    end
  end
end
