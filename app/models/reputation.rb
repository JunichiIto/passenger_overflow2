    #t.integer  "activity_id"
    #t.string   "activity_type"
    #t.integer  "user_id"
    #t.string   "reason"
    #t.integer  "point"
class Reputation < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, polymorphic: true

  validates :activity_id, presence: true 
  validates :activity_type, presence: true 
  validates :user_id, presence: true 
  validates :reason, presence: true, inclusion: %w{upvote accept accepted}
  validates :point, presence: true 

  default_scope order: "reputations.created_at DESC"

  def question
    activity.question
  end
end
