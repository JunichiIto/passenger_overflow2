class Question < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :answers

  validates :title, :presence => true, :length => { :maximum => 255 }
  validates :content, :presence => true
  validates :user_id, :presence => true

  default_scope :order => 'questions.created_at DESC'

  def accept(answer)
    self.update_attribute :accepted_answer_id, answer.id
  end

  def accepted_answer
    Answer.find_by_id accepted_answer_id
  end

  def accepted?
    accepted_answer_id
  end
end
