class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  
  validates :user_id, presence: true
  validates :answer_id, presence: true
  validate :first_vote?, on: :create

  def question
    answer.question
  end

  def first_vote?
    if !user.nil? && user.already_voted?(answer)
      errors.add :base, "Already voted"
    end
  end
end
