class Question < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :answers
  belongs_to :accepted_answer, class_name: "Answer"

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :user_id, presence: true
  validate :accepted_answer_overwritten?, on: :update

  default_scope order: "questions.created_at DESC"

  def accept(answer)
    self.class.transaction do
      self.accepted_answer = answer
      if changed? && save
        Reputation.create_for_accept! answer
      end
    end
  end

  def accepted?
    accepted_answer
  end

  private
  def accepted_answer_overwritten?
    if !accepted_answer_id_was.nil? && accepted_answer_id_changed?
      errors.add :base, "Already accepted"
    end
  end
end
