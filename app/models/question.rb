class Question < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :answers
  belongs_to :accepted_answer, class_name: "Answer"

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :user_id, presence: true
  validate :first_acception?, on: :update, if: :called_from_accept?

  default_scope order: "questions.created_at DESC"

  def accept(answer)
    self.class.transaction do
      self.accepted_answer = answer
      if save
        Reputation.create_for_accept! answer
      end
    end
  end

  def accepted?
    accepted_answer
  end

  private
  def first_acception?
    if !accepted_answer_id_was.nil?
      errors.add :base, "Already accepted"
    end
  end

  def called_from_accept?
    caller.find do |item|
      item =~ /\/#{self.class.name.underscore}\.rb.*accept/
    end
  end
end
