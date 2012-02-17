class Reputation < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, polymorphic: true

  validates :activity_id, presence: true 
  validates :activity_type, presence: true 
  validates :user_id, presence: true 
  validates :reason, presence: true, inclusion: %w{upvote accept accepted}
  validates :point, presence: true 

  default_scope order: "reputations.created_at DESC"

  def self.create_for_accept!(answer)
    teacher = answer.user
    asker = answer.question.user
    if teacher != asker
      asker.reputations.create! reason: "accepted", point: 2, activity: answer
      teacher.reputations.create! reason: "accept", point: 15, activity: answer
    end
  end

  def question
    activity.question
  end
end
