class Reputation < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, polymorphic: true

  default_scope order: "reputations.created_at DESC"

  def question
    if activity_type == "Vote"
      activity.answer.question
    else
      activity.question
    end
  end
end
